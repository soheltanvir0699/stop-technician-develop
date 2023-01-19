//
//  SMSVerificationTokenViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class SMSVerificationTokenViewController: StopAppBaseView, UITextFieldDelegate {
    
    
    @IBOutlet var pinView:UITextField! {
        didSet {
            pinView.keyboardType = .numberPad
            pinView.becomeFirstResponder()
            pinView.delegate = self
            pinView.addTarget(self, action: #selector(self.sendSMSVerification(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var buttonchecksmscode: TransitionButton! {
        didSet {
            self.buttonchecksmscode.addShadowBottom(UIColor.hexStringToUIColor(hex: "#E42F38"), height: 3.0)
            self.buttonchecksmscode.addTarget(self, action: #selector(self.didCheckSmsCode(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var buttonresendcode: UIButton! {
        didSet {
            buttonresendcode.isEnabled = false
//            buttonresendcode.addTarget(self, action: #selector(self.resendSMSVerificationCode(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var codeSendingInfo: UILabel!
    @IBOutlet weak var timerlabel: UILabel!
    @IBOutlet weak var buttonMarginBottom: NSLayoutConstraint!
    
    var seconds = 59
    var timer = Timer()
    var isTimerRunning = false
    
    var getName = ""
    var getFamilyName = ""
    var getEmail = ""
    var getSpecialized = 0
    var getExperience = 0
    var getInvitation = ""
    var getLatitude = 0.0
    var getLongitude = 0.0
    var getPhone = ""
    
    var isFromLogin = false
    var isUpdatePhone = false
    var invitationCode = ""
    
    var registerViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pinView.becomeFirstResponder()
        
        hideKeyboardWhenTappedAround(false)
        
        self.runTimer()
        
        let attributedString = NSMutableAttributedString()
        attributedString.normal(GusSetLanguage.getLanguage(key: "auth.phone.smsverification.title"), fontSize: 18.0)
            .bold("  " + self.getPhone.replacingOccurrences(of: "+", with: "") + "  ", fontSize: 18.0)
        self.codeSendingInfo.attributedText = attributedString
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        
        self.bindViewModel()
        
    }
    
    fileprivate func bindViewModel() {
        
        self.registerViewModel.updateLoadingStatus = {
            if self.registerViewModel.isLoading {
                self.showLoading()
                self.buttonchecksmscode.startAnimation()
            } else {
                self.dismissLoading()
                self.buttonchecksmscode.stopAnimation()
            }
        }
        
        //---------
        self.registerViewModel.showAlertClosure = {
            self.alertMessage(GusSetLanguage.getLanguage(key: "global.error.alert.title"), message: self.registerViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.buttonMarginBottom?.constant = 120.0
            } else {
                self.buttonMarginBottom?.constant = (endFrame?.size.height)! + 48
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    func runTimer() {
        seconds = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        self.timerlabel.text = "00:\(seconds)"
        if seconds == 0 {
            timer.invalidate()
            self.buttonresendcode.isEnabled = true
            self.runTimer()
        }
    }
    
    @objc func resendSMSVerificationCode(_ sender: UIButton) {
        runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
    }
    
    @objc func didCheckSmsCode(_ sender: TransitionButton) {
        
        let pin = self.pinView.text ?? ""
        
        if pin.isEmpty {
            self.alertMessage(GusSetLanguage.getLanguage(key: "global.error.alert.title"), message: GusSetLanguage.getLanguage(key: "auth.phone.verificationcode.empty"))
            self.pinView.becomeFirstResponder()
        } else {
            self.didSendingVerification(pin)
        }
    }
    
    func didSendingVerification(_ pin: String) {
        self.pinView.becomeFirstResponder()
        
        if isUpdatePhone {
            self.registerViewModel.didUpdatePhone(
            self.getPhone, pinCode: pin) {
                self.alertMessage(GusSetLanguage.getLanguage(key: "global.success.alert.title"), message: GusSetLanguage.getLanguage(key: "global.auth.phone.success.updated"), completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        } else {
            self.registerViewModel.verifyPhone(self.getEmail, phone: self.getPhone, verification_code: pin) {_ in
                if self.isFromLogin {
                    self.performSegue(withIdentifier: "homelogin", sender: self)
                    
                } else {
                    let bankController = UIStoryboard.init(name: "SettingView", bundle: Bundle.main).instantiateViewController(withIdentifier: "BankAccountEditableViewController") as! BankAccountEditableViewController
                    bankController.fromRegister = true
                    bankController.getPhone = self.getPhone
                    
                    self.navigationController?.pushViewController(bankController, animated: true)
                }
            }
        }
        
    }
    
    @objc func sendSMSVerification(_ sender: UITextField) {
        
        let textFieldPin = self.pinView.text ?? ""
        
        if textFieldPin.count == 4 {
            self.didSendingVerification(textFieldPin)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
    
}
