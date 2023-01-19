//  
//  HistoryViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class HistoryViewModel {

    private let service: HistoryServiceProtocol

    private var model: [Histories] = [Histories]() {
        didSet {
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
    var selectedObject: Histories?
    
    // model indexPath
    func dataOn(index: Int) -> Histories {
        return self.model[index]
    }
    
    var orderDetail: Orders?
    
    // network status checker
    var networkStatus = Reach().connectionStatus()
    
    // when disconnect, callback this
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = ErrorMessage.network.rawValue
            self.internetConnectionStatus?()
        }
    }

    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?

    init(withHistory serviceProtocol: HistoryServiceProtocol = HistoryService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func getHostiries(fetchMode: StopfetchType, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
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
            self.service.getHistory(offset: offset, success: { histories in
                
                self.isLoading = false
                if let history = histories.data {
                    if fetchMode == .fresh {
                        self.model = history
                    } else {
                        self.model += history
                    }
                }
                
                completion()
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                } else if errorCode == 0 {
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
    
    func orderWithDetail(_ id: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.detailHistory(id: id, success: { detail in
                
                self.isLoading = false
                self.orderDetail = detail.data
                completion()
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.isLoading = false
                } else if errorCode == 0 {
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

}

extension HistoryViewModel {

}
