//
//  SignInViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignInViewController: StopAppBaseView  {
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var flagCode: UIImageView! {
        didSet {
            flagCode.image = UIImage(named: "Countries.bundle/Images/SA", in: Bundle.main, compatibleWith: nil)
        }
    }
    @IBOutlet weak var phoneCodeText: UILabel! {
        didSet {
            self.phoneCodeText.text = self.selectedPhoneCode
        }
    }
    @IBOutlet weak var phoneCodeField: UIButton!
    
    @IBOutlet weak var loginbutton: UIButton! {
        didSet {
            loginbutton.addTarget(self, action: #selector(self.didLoginTap(_:)), for: .touchUpInside)
        }
    }
    
    var authViewModel = LoginViewModel()
    var selectedPhoneNumber = ""
    var selectedPhoneCode = "+966"
    var phoneNumberComplete = ""
    
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
    override func viewDidLayoutSubviews() {
        self.view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.authViewModel.updateLoadingStatus = {
            if self.authViewModel.isLoading {
                self.showLoading()
            } else {
                self.dismissLoading()
            }
        }
        
        //---------
        self.authViewModel.showAlertClosure = {
            self.alertMessage("", message: self.authViewModel.alertMessage ?? "", completion: {
                
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        IQKeyboardManager.shared.enable = true
        self.setArrowBack(imageArrow: UIImage(named: "right-arrow")!)
    }
    
    @objc func didLoginTap(_ sender: UIButton) {
        
        self.selectedPhoneNumber = self.phoneTextField.text ?? ""
        self.phoneNumberComplete = selectedPhoneCode + self.selectedPhoneNumber
        
        if self.phoneNumberComplete.isEmpty {
            self.alertMessage(GusSetLanguage.getLanguage(key: "global.error.alert.title"), message: GusSetLanguage.getLanguage(key: GusSetLanguage.getLanguage(key: "global.alert.phone.empty")))
        } else {
            self.authViewModel.auth(self.phoneNumberComplete) {
                let register = UIStoryboard.init(name: "RegisterView", bundle: Bundle.main).instantiateViewController(withIdentifier: "SMSVerificationTokenViewController") as! SMSVerificationTokenViewController
                
                register.getPhone = self.phoneNumberComplete
                register.isFromLogin = true
                
                self.navigationController?.pushViewController(register, animated: true)
            }
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
    
}

