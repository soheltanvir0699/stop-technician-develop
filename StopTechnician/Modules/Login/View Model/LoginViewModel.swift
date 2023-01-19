//  
//  LoginViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class LoginViewModel {

    private let service: LoginServiceProtocol

    private var model: User! {
        didSet {
            DispatchQueue.main.async {
                Profile.shared = self.model
                let token = Profile.shared?.token ?? ""
                UserToken.saveToken(token: token)
            }
        }
    }

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
    var selectedObject: LoginModel?

    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?

    init(withLogin serviceProtocol: LoginServiceProtocol = LoginService() ) {
        self.service = serviceProtocol
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func auth(_ phone: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.login(phone, success: { user in
                self.isLoading = false
                self.model = user
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

    func loadProfile(completion: @escaping() -> ()) {
        self.service.loadProfile {
            completion()
        }
    }

}

extension LoginViewModel {

}
