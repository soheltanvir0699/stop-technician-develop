//  
//  SettingView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class SettingView: StopAppBaseView {

    // OUTLETS HERE
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    // VARIABLES HERE
    // VARIABLES HERE
    var imageAvatarUser: UIImage!
    var imagePicker = UIImagePickerController()
    
    var settingViewModel = SettingViewModel()
    
    var getFullname     = ""
    var getEmail        = ""
    var getAddress      = ""
    var getPhone        = ""
    var getPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
    }
    
    fileprivate func initViewModel() {
        self.settingViewModel.showAlertClosure = {
            self.alertMessage("", message: self.settingViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.settingViewModel.updateLoadingStatus = {
            if self.settingViewModel.isLoading {
                self.showLoading()
            } else {
                self.dismissLoading()
            }
        }
        
        self.settingViewModel.profileUpdated = {
            self.alertMessage(
                GusSetLanguage.getLanguage(key: "global.success.alert.title"),
                message:
                GusSetLanguage.getLanguage(key: "global.alert.updateprofile")
                ,completion: {
                    self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
            })
        }
        
        self.settingViewModel.languageUpdated = {
            self.alertMessage(
                GusSetLanguage.getLanguage(key: "global.success.alert.title"),
                message:
                GusSetLanguage.getLanguage(key: "global.alert.updatelanguage")
                ,completion: {
                    self.tableView.reloadData()
                    self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                        let storyboard = UIStoryboard.init(name: "LoginView", bundle: nil)
                        let rootVC: SplashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                        self.present(rootVC, animated: true, completion: nil)
                    })
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        self.setNavigationBar(GusSetLanguage.getLanguage(key: "menu.setting.replace"), color: "E42F38", titleColor: "FFFFFF")
        self.navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
    }
    
    @IBAction func didDismissPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSaveProfile(_ sender: UIBarButtonItem) {
        self.settingViewModel.didProfileUpdate(
            self.getFullname,
            self.getEmail,
            self.getPhone,
            self.getAddress,
            photo: self.getPhoto)
    }
    
    @objc func didChangePhone(_ sender: UIButton) {
        let phoneBoard = UIStoryboard.init(name: "RegisterView", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
        phoneBoard.isUpdatePhone = true
        self.navigationController?.pushViewController(phoneBoard, animated: true)
    }
    
}

extension SettingView: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photo", for: indexPath) as! SettingViewCell
            
            cell.setupAvatar()
            
            cell.buttonChangePhoto.addTarget(self, action: #selector(self.openImageSelector(_:)), for: .touchUpInside)
            
            if self.imageAvatarUser != nil {
                cell.avatarImage.image = self.imageAvatarUser
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath) as! SettingViewCell
            
            
            cell.setupProfile()
            
            cell.fullname.delegate = self
            self.getFullname =  cell.fullname.text ?? ""
            cell.fullname.tag = 1
            
            cell.emailaddress.delegate = self
            self.getEmail = cell.emailaddress.text ?? ""
            cell.emailaddress.tag = 2
            
            // phone number target
            cell.buttonChangePhone.addTarget(self, action: #selector(self.didChangePhone(_:)), for: .touchUpInside)
            
            cell.address.delegate = self
            self.getAddress = cell.address.text ?? ""
            cell.address.tag = 3
            
            cell.phoneNumber.delegate = self
            self.getPhone = cell.phoneNumber.text ?? ""
            cell.phoneNumber.tag = 4
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "payout", for: indexPath) as! SettingViewCell
            
            cell.buttonBankAccount.addTarget(self, action: #selector(self.didBankAccountTap(_:)), for: .touchUpInside)
            
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "general", for: indexPath) as! SettingViewCell
            
            cell.buttonChangeLang.addTarget(self, action: #selector(self.didChangeLanguage(_:)), for: .touchUpInside)
            cell.buttonRateApp.addTarget(self, action: #selector(self.didRateApp(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    
    @objc func didBankAccountTap(_ sender: UIButton) {
         self.performSegue(withIdentifier: "bankaccount", sender: self)
    }
    
    @objc func didChangeLanguage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: GusSetLanguage.getLanguage(key: "global.languange.chooser.title"), message: GusSetLanguage.getLanguage(key: "global.languange.chooser.message"), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English", style: .default , handler:{ (UIAlertAction)in
            
            self.confirmationMessage(GusSetLanguage.getLanguage(key: "global.alert.confirm.language.update.title"), message: GusSetLanguage.getLanguage(key: "global.alert.confirm.language.update"), didOK: {
                
                GusLanguage.shared.setLanguage(language: "Base")
                Profile.shared?.lang = "en"
                self.settingViewModel.didLanguageUpdate("en", completion: {
                    exit(0)
                })
                
                
            })
            
           
        }))
        
        alert.addAction(UIAlertAction(title: "العربية", style: .default , handler:{ (UIAlertAction)in
            
            self.confirmationMessage(GusSetLanguage.getLanguage(key: "global.alert.confirm.language.update.title"), message: GusSetLanguage.getLanguage(key: "global.alert.confirm.language.update"), didOK: {
                
                GusLanguage.shared.setLanguage(language: "ar")
                Profile.shared?.lang = "ar"
                self.settingViewModel.didLanguageUpdate("ar", completion: {
                    exit(0)
                })
                
            })
            
            
        }))
        
        alert.addAction(UIAlertAction(title:GusSetLanguage.getLanguage(key: "global.string.cancel"), style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    @objc func didRateApp(_ sender: UIButton) {
        self.rateApp(appId: "1232232") { rated in
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let getActualText = (textField.text ?? "") + string
        
        switch textField.tag {
        case 1:
            self.getFullname = getActualText
        case 2:
            self.getEmail = getActualText
        case 3:
            self.getAddress = getActualText
        case 4:
            self.getPhone = getActualText
        default:
            break
        }
        
        return true
    }
    
}

