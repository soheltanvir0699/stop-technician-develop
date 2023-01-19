//
//  PhoneNumberViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PhoneNumberViewController: StopAppBaseView, UITextFieldDelegate {
    
    @IBOutlet weak var buttoncheckphone: TransitionButton! {
        didSet {
            self.buttoncheckphone.addShadowBottom(UIColor.hexStringToUIColor(hex: "#E42F38"), height: 3.0)
            self.buttoncheckphone.addTarget(self, action: #selector(self.didCheckPhone(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet  {
            phoneTextField.delegate = self
            phoneTextField.keyboardType = .phonePad
        }
    }
    
    @IBOutlet weak var flagCode: UIImageView!
    @IBOutlet weak var phoneCodeText: UILabel!
    @IBOutlet weak var phoneCodeField: UIButton!
    
    var getName = ""
    var getFamilyName = ""
    var getEmail = ""
    var getSpecialized = 0
    var getExperience = 0
    var getInvitation = ""
    var getLatitude = 0.0
    var getLongitude = 0.0
    
    var isUpdatePhone = false
    
    var selectedPhoneCode = "+966"
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    var registerViewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
        self.transparentBar()
        IQKeyboardManager.shared.enable = true
    }
    
    fileprivate func bindViewModel() {
        self.registerViewModel.updateLoadingStatus = {
            if self.registerViewModel.isLoading {
                self.showLoading()
                self.buttoncheckphone.startAnimation()
            } else {
                self.dismissLoading()
                self.buttoncheckphone.stopAnimation()
            }
        }
        
        //---------
        self.registerViewModel.showAlertClosure = {
            self.alertMessage("", message: self.registerViewModel.alertMessage ?? "", completion: {
                 self.buttoncheckphone.stopAnimation()
            })
        }
        
    }
    
    @objc func didCheckPhone(_ sender: TransitionButton) {
        
        let fieldPhone  = self.phoneTextField.text ?? ""
        let getPhone    = self.selectedPhoneCode + fieldPhone
        
        if fieldPhone.isEmpty {
            self.alertMessage(GusSetLanguage.getLanguage(key: "global.error.alert.title"), message: GusSetLanguage.getLanguage(key: "global.alert.phone.empty"))
        } else {
            sender.startAnimation()
            
            if self.isUpdatePhone {
                self.registerViewModel.requestPhoneUpdate(getPhone) {
                    sender.stopAnimation()
                    self.performSegue(withIdentifier: "smstoken", sender: self)
                }
            } else {
                self.registerViewModel.register(
                    self.getName,
                    family_name: self.getFamilyName,
                    email: self.getEmail,
                    specialized: self.getSpecialized,
                    experience: self.getExperience,
                    invitationCode: self.getInvitation,
                    phone: getPhone,
                    latitude: self.getLatitude,
                    longitude: self.getLongitude) {
                        
                        sender.stopAnimation()
                        self.performSegue(withIdentifier: "smstoken", sender: self)
                        
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "smstoken" {
            let destination = segue.destination as! SMSVerificationTokenViewController
            
            let fieldPhone  = self.phoneTextField.text ?? ""
            let getPhone    = self.selectedPhoneCode + fieldPhone
            
            destination.getName         = self.getName
            destination.getFamilyName   = self.getFamilyName
            destination.getEmail        = self.getEmail.lowercased()
            destination.getSpecialized  = self.getSpecialized
            destination.getExperience   = self.getExperience
            destination.getInvitation   = self.getInvitation
            destination.getLatitude     = self.getLatitude
            destination.getLongitude    = self.getLongitude
            destination.getPhone        = getPhone
            destination.isUpdatePhone   = self.isUpdatePhone
            
        }
    }
    
    @IBAction func selectPhoneCodes(_ sender: UIButton) {
        let alert = UIAlertController(style: self.alertStyle)
        alert.addLocalePicker(type: .phoneCode) { info in
            self.phoneCodeText.text = info?.phoneCode
            self.flagCode.image = info?.flag
            self.selectedPhoneCode = info?.phoneCode ?? ""
        }
        alert.addAction(title: GusSetLanguage.getLanguage(key: "global.string.cancel"), style: .cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func generatePhone(phoneCode: String) -> String {
        let phoneNumbers = phoneCode + "-" + self.phoneTextField.text!
        return phoneNumbers
    }
    
    func getPhoneCode(phone: String) -> String {
        let phoneCodeSplit = phone.replacingOccurrences(of: "+", with: "")
        return phoneCodeSplit
    }
    
    func getOnlyPhoneNumber(phone: String) -> String {
        let phoneCodeSplit = phone.components(separatedBy: "-")
        return phoneCodeSplit[1]
    }
    

}
