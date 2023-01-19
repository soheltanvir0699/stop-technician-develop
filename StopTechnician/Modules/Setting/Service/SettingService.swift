//  
//  SettingService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class SettingService: SettingServiceProtocol {
    
    func getCity(success: @escaping (Cities) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/resources/cities"
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Cities.self,
                        from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func getBank(cityName: String, success: @escaping (Banks) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/resources/bank/\(cityName)"
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Banks.self,
                        from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func getAllBank(success: @escaping (AllBank) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/account/bank"
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        AllBank.self,
                        from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func bankUser(id: Int, success: @escaping (GetBanks) -> (), failure: @escaping (String, Int) -> ()) {
    
        
        let endPoint = "engineer/account/bank/\(id)"
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        GetBanks.self,
                        from: data)
                    print("DDD: \(decoded)")
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func saveBankUser(account_name: String, account_number: String, address: String, city: String, bank_id: Int, success: @escaping (GetBanks) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/account/bank"
        
        let parameters: Parameters = [
            "account_name": account_name,
            "account_number": account_number,
            "address": address,
            "city": city,
            "bank_id": bank_id
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(GetBanks.self, from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func updateBankUser(id: Int, account_name: String, account_number: String, address: String, city: String, bank_id: Int, success: @escaping (UpdateBank) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/account/bank/\(id)"
        
        let parameters: Parameters = [
            "account_name": account_name,
            "account_number": account_number,
            "address": address,
            "city": city,
            "bank_id": bank_id
        ]
        
        APIManager.request(
            endPoint,
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(UpdateBank.self, from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func updateLanguage(_ lang: String, success: @escaping (User) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let endPoint = "engineer/\(idEngineer)/language"
        
        let parameters: Parameters = [
            "language" : lang
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(Profile.self, from: data)
                    success(decoded.data!)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func updateProfile(_ fullname: String, _ email: String, _ phone: String, _ address: String, photo: UIImage?, success: @escaping (User) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let url = "engineer/\(idEngineer)/updateprofile"
        
        print("HP: ", phone, "ALAMAT: ", address )
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(fullname.data(using: .utf8)!,
                                     withName: "name")
            multipartFormData.append(email.data(using: .utf8)!,
                                     withName: "email")
            multipartFormData.append(phone.data(using: .utf8)!,
                                     withName: "phone")
            multipartFormData.append(address.data(using: .utf8)!,
                                     withName: "address")
            
            let language = GusLanguage.shared.currentLang
            multipartFormData.append(language.data(using: .utf8)!, withName: "lang")
            
            
            
            if photo != nil {
                let imageData = photo?.jpegData(compressionQuality: 0.4)
                multipartFormData.append(imageData!, withName: "photo", fileName: "photo", mimeType: "image/png")
            }
            
        },
            usingThreshold: UInt64.init(),
            to: APIEnvironment.baseURL + url,
            method: .post,
            headers: APIManager.requestHeader()) { (result) in
                print("DING DING: 0 = \(result)")
                switch result{
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { response in
                        
                        print("DING DING: \(response)")
                        
                        if response.response?.statusCode == 200 {
                            guard let callback = response.data else {
                                failure(APIManager.generateRandomError(), 0)
                                return
                            }
                            
                            // mapping data
                            do {
                                let decoded = try JSONDecoder().decode(Profile.self, from: callback)
                                success(decoded.data!)
                            } catch _ {
                                failure(APIManager.generateRandomError(), 0)
                            }
                            
                        } else if response.response?.statusCode == 401 {
                            StopAppBaseView.logoutApp()
                        } else {
                            guard let callbackError = response.data else {
                                return
                            }
                            
                            do {
                                let decoded = try JSONDecoder().decode(
                                    APIError.self, from: callbackError)
                                if let messageError = decoded.data?.errors?.messages {
                                    let messages = messageError.joined(separator: ", ")
                                    failure(messages, 0)
                                } else {
                                    failure(APIManager.generateRandomError(), 0)
                                }
                            } catch _ {
                                failure(APIManager.generateRandomError(), 0)
                            }
                        }
                        
                    })
                case .failure( _):
                    failure(APIManager.generateRandomError(), 0)
                }
        }
        
    }
    
}
