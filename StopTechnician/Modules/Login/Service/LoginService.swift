//  
//  LoginService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class LoginService: LoginServiceProtocol {
    // Call protocol function
    
    func login(_ phone: String, success: @escaping (User) -> (), failure: @escaping (_ msg: String, _ errorCode: Int) -> ()) {
        
        let url = "engineer/auth"
        
        let parameters: Parameters = [
            "phone": phone
        ]
        
        APIManager.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Profile.self, from: data)
                    success(decoded.data!)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { msg, errorCode  in
            failure(msg, errorCode)
        }
        
    }
    
    func loadProfile(completion: @escaping () -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let endPoint = "engineer/\(idEngineer)"
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Profile.self, from: data)
                    
                    Profile.shared = decoded.data
                    completion()
                    
                } catch _ {
                    completion()
                }
                
        }) { _, _  in
            completion()
        }
    }
    
    
}
