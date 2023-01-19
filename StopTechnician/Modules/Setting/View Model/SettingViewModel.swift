//  
//  SettingViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit


class SettingViewModel {

    private let service: SettingServiceProtocol

    private var model: [SettingModel] = [SettingModel]()

    // update loading status
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var cityLoading: Bool = false {
        didSet {
            self.isCityLoadingStatus?()
        }
    }
    
    var bankLoading: Bool = false {
        didSet {
            self.isBankLoadingStatus?()
        }
    }
    
    // show alert message
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    // selected model
    var selectedObject: SettingModel?
    var getBanks: BankData?
    
    var bank = [Bank]()
    
    func getBankString() -> [String] {
        var theBank = [String]()
        for i in self.bank {
            theBank.append(i.name ?? "")
        }
        return theBank
    }
    
    func getBankId() -> [Int] {
        var theBankId = [Int]()
        for i in self.bank {
            theBankId.append(i.id ?? 0)
        }
        return theBankId
    }
    
    var city = [String]()
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
    var isCityLoadingStatus: (() -> ())?
    var isBankLoadingStatus: (() -> ())?
    var profileUpdated: (() -> ())?
    var languageUpdated: (() -> ())?
    var serverErrorStatus: (() -> ())?


    init(withSetting serviceProtocol: SettingServiceProtocol = SettingService() ) {
        self.service = serviceProtocol
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }
    
    func getCity(completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.cityLoading = true
            self.service.getCity(success: { cities in
                
                self.cityLoading = false
                if let cityAppend = cities.data {
                    self.city = cityAppend
                }
                
                completion()
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.cityLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.cityLoading = false
                }
            }
        default:
            break
        }
    }
    
    func getBank(cityName: String, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.bankLoading = true
            self.service.getBank(cityName: cityName, success: { banks in
                
                self.bankLoading = false
                if let appendBank = banks.data {
                    self.bank = appendBank
                }
                completion()
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                }
            }
        default:
            break
        }
    }
    
    func getAllBankUser(completion: @escaping(_ id: Int) -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.bankLoading = true
            self.service.getAllBank(success: { (all) in
                
                self.bankLoading = false
                completion(all.data?.first?.id ?? 0)
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                } else {
//                    self.alertMessage = errorMsg
                    self.bankLoading = false
                }
            }
        default:
            break
        }
    }
    
    func bankUser(id: Int, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.bankLoading = true
            self.service.bankUser(id: id, success: { banks in
            
                self.bankLoading = false
                self.getBanks = banks.data
                completion()
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                } else {
//                    self.alertMessage = errorMsg
                    self.bankLoading = false
                }
            }
        default:
            break
        }
    }
    
    func saveBankUser(account_name: String, account_number: String, address: String, city: String, bank_id: Int, completion: @escaping() -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.bankLoading = true
            self.service.saveBankUser(account_name: account_name, account_number: account_number, address: address, city: city, bank_id: bank_id, success: { success in
                
                self.bankLoading = false
                self.getBanks = success.data
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                }
            }
        default:
            break
        }
    }
    
    func updateBankUser(id: Int, account_name: String, account_number: String, address: String, city: String, bank_id: Int, completion: @escaping(_ msg: String) -> ()) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.bankLoading = true
            self.service.updateBankUser(id: id, account_name: account_name, account_number: account_number, address: address, city: city, bank_id: bank_id, success: { success in
                
                self.bankLoading = false
                completion(success.data?.message ?? "")
                
            }) { errorMsg, errorCode  in
                if errorCode == ErrorCode.unregistered.rawValue {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                } else {
                    self.alertMessage = errorMsg
                    self.bankLoading = false
                }
            }
        default:
            break
        }
    }
    
    func didProfileUpdate(_ fullname: String, _ email: String, _ phone: String, _ address: String, photo: UIImage?) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.updateProfile(
                fullname,
                email,
                phone,
                address,
                photo: photo,
                success: { user in
                    self.isLoading = false
                    Profile.shared = user
                    self.profileUpdated?()
            }) { errorMsg, errorCode in
                if errorCode == 0 {
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
    
    func didLanguageUpdate(_ language: String, completion: @escaping() -> Void) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.updateLanguage(language, success: { user in
                
                self.isLoading = false
                Profile.shared = user
                self.languageUpdated?()
                completion()
                
            }) { errorMsg, errorCode in
                if errorCode == 0 {
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
    
    func generateIBANNumber(iban: String) -> String {
        let ibanNumber = iban.replacingOccurrences(of: " ", with: "")
        let replaceDash = ibanNumber.replacingOccurrences(of: "-", with: " ")
        return replaceDash
    }
    
    

}

extension SettingViewModel {

}
