//  
//  MyWorkViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class MyWorkViewModel {

    private let service: MyWorkServiceProtocol

    private var model: [Working] = [Working]() {
        didSet {
            
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
    
    var count: Int?

    // selected model
    func selectedObject(index: Int) -> Working? {
        return self.model[index]
    }
    
    var orderDetail: Orders?
    

    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    
    
    init(withMyWork serviceProtocol: MyWorkServiceProtocol = MyWorkService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func didGetWork(completion: @escaping() -> ()) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.getMyWork(success: { work in
                self.isLoading = false
                self.count = work.data?.count ?? 0
                if let fetchWork = work.data {
                    self.model = fetchWork
                }
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
    
    func didGetBids(completion: @escaping() -> ()) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.getMyBids(success: { work in
                self.isLoading = false
                self.count = work.data?.count ?? 0
                if let fetchBid = work.data {
                    self.model = fetchBid
                }
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
    
    func orderWithDetail(_ id: String, completion: @escaping() -> ()) {
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
    
    func completeWork(_ id: String, completion: @escaping(String) -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            
            self.service.completeWork(id: id, success: { success in
                self.isLoading = false
                completion(success.data?.message ?? "")
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
    
    func rateTheOrder(_ id: String, rate: Double, message: String, completion: @escaping(String) -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            
            self.service.rateOrder(id: id, rate: rate, message: message, success: { success in
                
                self.isLoading = false
                completion(success.data?.message ?? "")
                
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

}

extension MyWorkViewModel {

}
