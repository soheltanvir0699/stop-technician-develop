//  
//  BiddingViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class BiddingViewModel {

    private let service: BiddingServiceProtocol

    private var model: [BiddingModel] = [BiddingModel]()

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
    
    // network status checker
    var networkStatus = Reach().connectionStatus()
    
    // when disconnect, callback this
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = ErrorMessage.network.rawValue
            self.internetConnectionStatus?()
        }
    }

    // selected model
    var selectedObject: BiddingModel?
    var orderDetail: Orders?

    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?

    init(withBidding serviceProtocol: BiddingServiceProtocol = BiddingService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func didBidSubmit(_ id: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.didSubmitOrder(id: id, success: {
                
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
    
    func getBidContent(_ id: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.detailBidContent(id: id, success: { details in
                
                self.isLoading = false
                self.orderDetail = details.data
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

}

extension BiddingViewModel {

}
