//  
//  RegisterService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class RegisterService: RegisterServiceProtocol {
    
    func getCategories(completion: @escaping (Specialization) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/resources/specialization"
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Specialization.self,
                        from: data)
                    completion(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func register(_ name: String, family_name: String, email: String, specialized: Int, experience: Int, invitationCode: String, phone: String, latitude: Double, longitude: Double, success: @escaping (APISuccess) -> (), failure: @escaping (String, Int) -> ()) {
        
        
        let endPoint = "engineer/register"
        
        let parameters: Parameters = [
            "name": name,
            "family_name": family_name,
            "email": email,
            "specialized": specialized,
            "experience": experience,
            "invitation_code": invitationCode,
            "phone": phone,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        APISuccess.self,
                        from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func verificationPhone(_ email: String, phone: String, verification_code: String, success: @escaping (User) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/verifyphone"
        
        let parameters: Parameters = [
            "email": email,
            "phone": phone,
            "verification_code": verification_code
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Profile.self,
                        from: data)
                    
                    Profile.shared = decoded.data!
                    success(decoded.data!)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
    }
    
    func saveBank(_ accountName: String, accountNumber: String, address: String, city: String, success: @escaping (String) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/account/bank"
        
        let parameters: Parameters = [
            "account_name": accountName,
            "account_number": accountName,
            "address": address,
            "city": city
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        APISuccess.self,
                        from: data)
                    success(decoded.data?.message ?? "")
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func requestUpdatePhone(_ phoneNumber: String, success: @escaping () -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let url = "engineer/\(idEngineer)/updatephone"
        
        let params: Parameters = [
            "phone" : phoneNumber,
            ]
        
        APIManager.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                success()
        }) { errorMsg, errorCode in
            failure(errorMsg, errorCode)
        }
    }
    
    func didUpdatePhone(_ phone: String, pinCode: String, success: @escaping (_ data: Profile) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let url = "engineer/\(idEngineer)/updatephone/submit"
        
        let params: Parameters = [
            "phone" : phone,
            "verification_code": pinCode
        ]
        
        APIManager.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                do {
                    let decoded = try JSONDecoder().decode(
                        Profile.self, from: data)
                    
                    Profile.shared = decoded.data
                    
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
        }) { errorMsg, errorCode in
            failure(errorMsg, errorCode)
        }
        
    }
    
}
