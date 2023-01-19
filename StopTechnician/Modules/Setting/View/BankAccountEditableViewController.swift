//
//  BankAccountEditableViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CoreLocation
import MapKit
import OneSignal

struct IBANNumber {
    static let format1 = "SA 00-0000-0000-0000-0000-0000"
    static let mask    = "***dd*dddd*dddd*dddd*dddd*dddd"
}

class BankAccountEditableViewController: StopAppBaseView {
    
    
    @IBOutlet weak var bankAccountName: AnimatedTextInput! {
        didSet {
//            self.bankAccountName.placeHolderText = "Bank account name"
            self.bankAccountName.type = .standard
            self.bankAccountName.style = AuthInputStyle()
        }
    }
    @IBOutlet weak var addressUser: AnimatedTextInput! {
        didSet {
//            self.addressUser.placeHolderText = "Address"
            self.addressUser.type = .standard
            self.addressUser.style = AuthInputStyle()
        }
    }
    @IBOutlet weak var citySelected: UIButton! {
        didSet {
            citySelected.isEnabled = false
            citySelected.addTarget(self, action: #selector(self.showCity(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var bankSelected: UIButton! {
        didSet {
            self.bankSelected.isEnabled = false
            self.bankSelected.addTarget(self, action: #selector(self.showBanks(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var ibanNumber: KCMaskTextField! {
        didSet {
            self.ibanNumber.setFormat(IBANNumber.format1, mask: IBANNumber.mask)
        }
    }
    
    @IBOutlet weak var buttonSave: UIButton! {
        didSet {
            if fromRegister {
                self.buttonSave.setBackgroundColor(color: UIColor.hexStringToUIColor(hex: "E42F38"), forState: .normal)
            } else {
                self.buttonSave.setBackgroundColor(color: UIColor.hexStringToUIColor(hex: "273D52"), forState: .normal)
            }
            self.buttonSave.addTarget(self, action: #selector(self.didSaveBank(_:)), for: .touchUpInside)
        }
    }
    
    var settingViewMmodel = SettingViewModel()
    var cityName = ""
    var idBank = 0
    var getIdBankUser = 0
    
    var fromRegister = false
    var getPhone = ""
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        
        self.setupNotificationAlert()
        self.setupLocationPermission()
        
    }
    
    func setupLocationPermission() {
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
    }
    
    func setupNotificationAlert() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            if accepted == true {
                print("User accepted notifications: \(accepted)")
                DispatchQueue.main.async {
                    // register Onesignal
                    OneSignal.sendTag("phone", value: self.getPhone)
                    OneSignal.setSubscription(true)
                }
            } else {
                
                self.displaySettingsNotification()
            }
        })
    }
    
    func displaySettingsNotification() {
        let message = NSLocalizedString("Please turn on notifications by going to Settings > Notifications > Allow Notifications", comment: "Alert message when the user has denied access to the notifications")
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        });
        self.displayAlert(title: message, message: "Stop Technician", actions: [settingsAction])
    }
    
    func displayAlert(title : String, message: String, actions: [UIAlertAction]) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert);
        actions.forEach { controller.addAction($0) };
        self.present(controller, animated: true, completion: nil);
    }
    
    fileprivate func initViewModel() {
        
        self.settingViewMmodel.showAlertClosure = {
            self.alertMessage("", message: self.settingViewMmodel.alertMessage ?? "")
        }
        
        self.settingViewMmodel.isCityLoadingStatus = {
            if self.settingViewMmodel.cityLoading {
                self.citySelected.showSpinner()
            } else {
                self.citySelected.hideSpinner()
            }
        }
        
        self.settingViewMmodel.isBankLoadingStatus = {
            if self.settingViewMmodel.bankLoading {
                self.bankSelected.showSpinner()
            } else {
                self.bankSelected.hideSpinner()
            }
        }
        
        DispatchQueue.main.async {
            self.settingViewMmodel.getCity {
                self.citySelected.isEnabled = true
            }
            
        }
        
        self.settingViewMmodel.getAllBankUser { idBankUser in
            self.getIdBankUser = idBankUser
            self.settingViewMmodel.bankUser(id: idBankUser, completion: {
                self.bankAccountName.text = self.settingViewMmodel.getBanks?.accountName ?? ""
                self.addressUser.text = self.settingViewMmodel.getBanks?.address ?? ""
                self.ibanNumber.text = self.settingViewMmodel.getBanks?.accountNumber ?? ""
                self.citySelected.setTitle(self.settingViewMmodel.getBanks?.city ?? "", for: .normal)
                self.bankSelected.setTitle(self.settingViewMmodel.getBanks?.bank?.name ?? "", for: .normal)
                
                //
                self.idBank     = self.settingViewMmodel.getBanks?.bank?.id ?? 0
                self.cityName   = self.settingViewMmodel.getBanks?.city ?? ""
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.transparentBar()
        self.navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: "FFF")
        self.setArrowBack(imageArrow: UIImage(named: "right-arrow")!)
    }
    
    @objc func showCity(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: GusSetLanguage.getLanguage(key: "setting.bank.city.title.dialog"), rows: self.settingViewMmodel.city, initialSelection: 0, doneBlock: { (picker, index, value) in
            
            let city = value as! String
            
            self.citySelected.setTitle(city, for: .normal)
            self.cityName = city
            
            DispatchQueue.main.async {
                self.settingViewMmodel.getBank(cityName: self.cityName, completion: {
                    self.bankSelected.isEnabled = true
                })
            }
            
        }, cancel: { cancel in
            
        }, origin: sender)
    }
    
    @objc func showBanks(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "", rows: self.settingViewMmodel.getBankString(), initialSelection: 0, doneBlock: { (picker, index, value) in
            
            let bank = value as! String
            
            self.bankSelected.setTitle(bank, for: .normal)
            self.idBank = self.settingViewMmodel.getBankId()[index]
            
        }, cancel: { cancel in
            
        }, origin: sender)
    }
    
    @objc func didSaveBank(_ sender: UIButton) {
        let getIBAN = self.ibanNumber.text ?? ""
        let iban = self.settingViewMmodel.generateIBANNumber(iban: getIBAN)
        
        if fromRegister {
            
            self.settingViewMmodel.saveBankUser(
                account_name: self.bankAccountName.text ?? "",
                account_number: iban,
                address: self.addressUser.text ?? "",
                city: self.cityName,
                bank_id: self.idBank) {
                    
                    let referralController = UIStoryboard.init(name: "RegisterView", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvitationCodeViewController") as! InvitationCodeViewController
                    self.navigationController?.pushViewController(referralController, animated: true)
                    
            }
            
        } else {
            
            if self.getIdBankUser == 0 {
                self.settingViewMmodel.saveBankUser(
                    account_name: self.bankAccountName.text ?? "",
                    account_number: iban,
                    address: self.addressUser.text ?? "",
                    city: self.cityName,
                    bank_id: self.idBank) {
                        
                        self.alertMessage(GusSetLanguage.getLanguage(key: "global.success.alert.title"), message: GusSetLanguage.getLanguage(key: "setting.bank.save.success.alert"), completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                }
            } else {
                self.settingViewMmodel.updateBankUser(
                    id: self.getIdBankUser,
                    account_name: self.bankAccountName.text ?? "",
                    account_number: iban,
                    address: self.addressUser.text ?? "",
                    city: self.cityName,
                    bank_id: self.idBank) { msg in
                        self.alertMessage(GusSetLanguage.getLanguage(key: "global.success.alert.title"), message: msg, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                }
            }
        }
        
    }

}

extension UIAlertAction {
    static func okAction() -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil);
    }
}
