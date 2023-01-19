//  
//  RegisterViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class RegisterViewModel {

    private let service: RegisterServiceProtocol

    private var model: [RegisterModel] = [RegisterModel]()
    
    // network status checker
    var networkStatus = Reach().connectionStatus()

    // update loading status
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    // show alert message
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    // when disconnect, callback this
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = ErrorMessage.network.rawValue
            self.internetConnectionStatus?()
        }
    }
    
    // selected model
    var selectedObject: RegisterModel?

    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?

    init(withRegister serviceProtocol: RegisterServiceProtocol = RegisterService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func register(_ name: String, family_name: String, email: String, specialized: Int, experience: Int, invitationCode: String, phone: String, latitude: Double, longitude: Double, completion: @escaping() -> ()) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.register(name, family_name: family_name, email: email, specialized: specialized, experience: experience, invitationCode: invitationCode, phone: phone, latitude: latitude, longitude: longitude, success: { success in
                
                self.isLoading = false
                completion()
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                }
            }
        default:
            break
        }
    }
    
    func verifyPhone(_ email: String, phone: String, verification_code: String, completion: @escaping(_ invitationCode: String) -> ()) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.verificationPhone(email, phone: phone, verification_code: verification_code, success: { use in
                
                self.isLoading = false
                
                Profile.shared = use
                let token = Profile.shared?.token ?? ""
                UserToken.saveToken(token: token)
                
                completion("")
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                }
            }
        default:
            break
        }
    }
    
    func saveBank(_ accountName: String, accountNumber: String, address: String, city: String, completion: @escaping() -> ()) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.saveBank(accountName, accountNumber: accountNumber, address: address, city: city, success: { success in
                self.isLoading = false
                completion()
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                }
            }
        default:
            break
        }
        
    }
    
    func requestPhoneUpdate(_ phone: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            if phone.isEmpty {
                self.alertMessage = GusSetLanguage.getLanguage(key: "auth.phone.alert.phoneEmpty")
            } else {
                self.isLoading = true
                self.service.requestUpdatePhone(phone, success: {
                    self.isLoading = false
                    completion()
                }) { errorMsg, errorCode in
                    if errorCode == 0 {
                        self.isLoading = false
                        self.serverErrorStatus?()
                    } else {
                        self.isLoading = false
                        self.alertMessage = errorMsg
                    }
                }
            }
        default:
            break
        }
    }
    
    func didUpdatePhone(_ phone: String, pinCode: String, completion: @escaping() -> ()) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            if phone.isEmpty {
                self.alertMessage = GusSetLanguage.getLanguage(key: "auth.phone.alert.phoneEmpty")
            } else if pinCode.isEmpty {
                self.alertMessage = GusSetLanguage.getLanguage(key: "auth.phone.verificationcode.empty")
            } else {
                self.isLoading = true
                self.service.didUpdatePhone(
                    phone,
                    pinCode: pinCode, success: { _ in
                        self.isLoading = false
                        completion()
                }) { errorMsg, errorCode in
                    if errorCode == 0 {
                        self.isLoading = false
                        self.serverErrorStatus?()
                    } else {
                        self.isLoading = false
                        self.alertMessage = errorMsg
                    }
                }
            }
        default:
            break
        }
        
    }

}
