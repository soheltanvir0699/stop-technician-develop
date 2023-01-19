//  
//  HomeViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class HomeViewModel {

    private let service: HomeServiceProtocol

    private var model: Summary? {
        didSet {
            self.currentJob = model?.data?.todayService
            _ = self.countJobs()
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
    
    var statusLoading: Bool = false {
        didSet {
            self.updateLoading?()
        }
    }

    // show alert message
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    func getData(index: Int) -> AvailableOrder? {
        return self.model?.data?.availableOrder?[index]
    }
    var currentJob: TodayService?
    
    func countJobs() -> Int {
        return self.model?.data?.availableOrder?.count ?? 3
    }
    
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
    var updateLoading: (() -> ())?
    var summaryloaded: (() ->())?

    init(withHome serviceProtocol: HomeServiceProtocol = HomeService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    func getJobsToday() {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            
            DispatchQueue.main.async {
                self.service.getJobsToday(success: { summary in
                    
                    DispatchQueue.main.async {
                        self.model = summary
                        self.isLoading = false
                        self.summaryloaded?()
                    }
                    
                }) { errorMsg, errorCode  in
                    
                    if errorCode == ErrorCode.unregistered.rawValue {
                        self.alertMessage = errorMsg
                        self.isLoading = false
                    } else {
                        self.alertMessage = errorMsg
                        self.isLoading = false
                    }
                    
                }
            }
            
        default:
            break
        }
    }
    
    func switchStatus(status: Bool, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.statusLoading = true
            
            self.service.switchStatus(status: status, success: { _ in
                self.statusLoading = false
                completion()
            })  {errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.statusLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.statusLoading = false
                }
            }
            
        default:
            break
        }
    }
    
}

extension HomeViewModel {

}
