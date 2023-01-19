//  
//  RegisterServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol RegisterServiceProtocol {
    
    func getCategories(completion: @escaping(_ data: Specialization) -> (), failure: @escaping(_ msg: String, _ errorCode: Int) -> ())
    
    
    /// REGISTER
    ///
    /// - Parameters:
    ///   - name: fullname user
    ///   - email: email user
    ///   - specialized: specialized user
    ///   - experience: experience user
    ///   - invitationCode: invitation code
    ///   - phone: phone description
    ///   - latitude: latitude user
    ///   - longitude: longitude user
    ///   - success: success response
    ///   - failure: failure response
    func register(_ name: String, family_name: String, email: String, specialized: Int, experience: Int, invitationCode: String, phone: String, latitude: Double, longitude: Double, success: @escaping(APISuccess) -> (), failure: @escaping(_ msg: String, _ errorCode: Int) -> ())
    
    
    /// VERIFICATION MOBILE PHONE
    ///
    /// - Parameters:
    ///   - email: email user
    ///   - phone: phone user
    ///   - verification_code: verificatin code sent by SMS
    ///   - success: success response
    ///   - failre: failure response
    func verificationPhone(_ email: String, phone: String, verification_code: String, success:@escaping (User) -> (), failure: @escaping(_ msg: String, _ errorCode: Int) -> ())
    
    
    /// SAVE BANK USER
    ///
    /// - Parameters:
    ///   - accountName: account name
    ///   - accountNumber: account number
    ///   - address: address user
    ///   - city: city user
    ///   - success: success response
    ///   - failure: failure response
    func saveBank(_ accountName: String, accountNumber: String, address: String, city: String, success: @escaping(String) -> (), failure: @escaping(_ msg: String, _ errorCode: Int) -> ())
    
    /// UPDATE PHONE NUMBER
    ///
    /// - Parameters:
    ///   - phoneNumber: phone number
    ///   - success: success response
    ///   - failure: failure response
    func requestUpdatePhone(_ phoneNumber: String, success: @escaping() -> (), failure: @escaping(String, Int) -> ())
    
    
    /// UPDATE PHONE NUMBER
    ///
    /// - Parameters:
    ///   - phone: phone number
    ///   - pinCode: pin code sms
    ///   - success: success response
    ///   - failure: failure response
    func didUpdatePhone(_ phone: String, pinCode: String, success: @escaping(_ data: Profile) -> (), failure: @escaping(String, Int) -> ())
    
}
