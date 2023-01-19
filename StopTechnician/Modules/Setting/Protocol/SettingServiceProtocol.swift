//  
//  SettingServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import UIKit

protocol SettingServiceProtocol {
    
    
    /// CITY NAME LIST
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response
    /// - Returns: return
    func getCity(success: @escaping(Cities) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// BANK LIST
    ///
    /// - Parameters:
    ///   - cityName: city name
    ///   - success: success response
    ///   - failure: failure response
    /// - Returns: return
    func getBank(cityName: String, success: @escaping(Banks) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// GET ALL BANK USERS
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response
    /// - Returns: -
    func getAllBank(success: @escaping(AllBank) -> (), failure: @escaping(String, Int) -> ())
    
    /// GET BANK USER
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response
    /// - Returns: return
    func bankUser(id: Int, success: @escaping(GetBanks) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// SAVE BANK USER
    ///
    /// - Parameters:
    ///   - account_name: account name
    ///   - account_number:
    ///   - address:
    ///   - city:
    ///   - bank_id:
    ///   - success:
    ///   - failure:
    /// - Returns: 
    func saveBankUser(account_name: String, account_number: String, address: String, city: String, bank_id: Int, success: @escaping(GetBanks) -> (), failure: @escaping(String, Int) -> ())
    
    /// UPDATE BANK USER
    ///
    /// - Parameters:
    ///   - id: id bank
    ///   - account_name: account name
    ///   - account_number:
    ///   - address:
    ///   - city:
    ///   - bank_id:
    ///   - success:
    ///   - failure:
    /// - Returns:
    func updateBankUser(id: Int, account_name: String, account_number: String, address: String, city: String, bank_id: Int, success: @escaping(UpdateBank) -> (), failure: @escaping(String, Int) -> ())
    
    /// UPDATE PROFILE
    ///
    /// - Parameters:
    ///   - fullname: fullname user
    ///   - email: email user
    ///   - phone: phone user
    ///   - address: address user
    ///   - photo: photo user
    ///   - success: success resonse
    ///   - failure: failure response
    /// - Returns: return User Profile
    func updateProfile(_ fullname: String, _ email: String, _ phone: String, _ address: String, photo: UIImage?, success: @escaping(User) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// UPDATE LANGUAGE
    ///
    /// - Parameters:
    ///   - lang: language string
    ///   - success: success response
    ///   - failure: failure response
    func updateLanguage(_ lang: String, success: @escaping(User) -> (), failure: @escaping(String, Int) -> ())
    
    
}
