//  
//  NotificationViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class NotificationViewModel {

    private let service: NotificationServiceProtocol

    private var model: [Notif] = [Notif]() {
        didSet {
            self.data = self.model
            self.count = self.model.count
        }
    }
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
    
    var count: Int?

    // selected model
    var selectedObject: Notif?
    var data = [Notif]()
    var orderDetail: Orders?
    
    // network status checker
    var networkStatus = Reach().connectionStatus()
    
    // when disconnect, callback this
    var isDisconnected: Bool = false {
        didSet {
            //            self.alertMessage = ErrorMessage.network.rawValue
            self.internetConnectionStatus?()
        }
    }
    
    
    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?

    init(withNotification serviceProtocol: NotificationServiceProtocol = NotificationService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func getNotifications(fetchMode: StopfetchType, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            completion()
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            
            var offset = 0
            
            if fetchMode == .more {
                offset = self.model.count
            } else {
                offset = 0
            }
            
            self.isLoading = true
            self.service.getNotification(offset: offset, fetchType: fetchMode, success: { notifications in
                
                self.isLoading = false
                if let notifs = notifications.data {
                    if fetchMode == .fresh {
                        self.model = notifs
                    } else {
                        self.model += notifs
                    }
                }
                
                completion()
                
            }) { errorMsg, errorCode in
                completion()
                if errorCode == 0 {
                    self.isLoading = false
                    self.serverErrorStatus?()
                } else {
                    self.isLoading = false
                    self.alertMessage = errorMsg
                }
            }
        default:
            break
        }
    }
    
    func notificationOrder(_ id: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.getOrderDetail(id: id, success: { detail in
                
                self.isLoading = false
                self.orderDetail = detail.data
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
    
    func acceptOrder(_ id: String, completion: @escaping(String) -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.acceptOrder(id: id, success: { accepted in
                self.isLoading = false
                completion(accepted.data?.message ?? "")
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
    
    func rejectOrder(_ id: String, completion: @escaping(String) -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.rejectOrder(id: id, success: { rejected in
                self.isLoading = false
                completion(rejected.data?.message ?? "")
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
    
    func readNotification(id: Int, completion: @escaping() -> ()) {
        self.service.notifIsRead(notifid: id) {
            completion()
        }
    }
    

}

extension NotificationViewModel {

}
