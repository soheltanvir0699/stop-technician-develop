//  
//  WalletViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class WalletViewModel {

    private let service: WalletServiceProtocol

    private var model: [WalletHistory] = [WalletHistory]() {
        didSet {
            if self.model[0].activity?.isEmpty ?? true {
                self.countSection = 0
            } else {
                self.countSection = model.count
            }
        }
    }
    
    private var monthly: [WalletMonthly] = [WalletMonthly]() {
        didSet {
            self.countMonthly = self.monthly.count
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
    
    var getAmountWeekly: Double?
    
    var  countSection: Int = 0
    func count(section: Int) -> Int? {
        return self.model[section].activity?.count
    }
    
    func getData(At section: Int, index: Int) -> WalletActivity? {
        return self.model[section].activity?[index]
    }
    
    func getData(At section: Int) -> WalletHistory {
        return self.model[section]
    }
    
    // Mothly wallet
    var countMonthly: Int?
    
    func monthlyData(_ index: Int) -> WalletMonthly {
        return self.monthly[index]
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

    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?

    init(withWallet serviceProtocol: WalletServiceProtocol = WalletService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func didGetWallet(fetchMode: StopfetchType, completion: @escaping() -> ()) {
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
            self.service.getWalletHistory(offset: offset, success: { wallets in
                
                self.isLoading = false
                if let wallet = wallets.data?.history {
                    if fetchMode == .fresh {
                        self.model = wallet
                        self.getAmountWeekly = wallets.data?.amount ?? 0.0
                    } else {
                        self.model += wallet
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
    
    func didGetWalletMonthly(fetchMode: StopfetchType, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            
            var offset = 0
            
            if fetchMode == .more {
                offset = self.monthly.count
            } else {
                offset = 0
            }
            
            self.isLoading = true
            
            self.service.monthlyWalletHistory(offset: offset, success: { wallets in
                
                self.isLoading = false
                if let wallet = wallets.data?.history {
                    if fetchMode == .fresh {
                        self.monthly = wallet
                    } else {
                        self.monthly += wallet
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

}

extension WalletViewModel {

}
