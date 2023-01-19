//  
//  HomeService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class HomeService: HomeServiceProtocol {
    
    func getJobsToday(success: @escaping (Summary) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/summary"
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(
                            Summary.self,
                            from: data)
                        success(decoded)
                    } catch _ {
                        failure(APIManager.generateRandomError(), 0)
                    }
                }
                
        }) { errorMsg, errorCode in
            failure(errorMsg, errorCode)
        }
        
    }
    
    func switchStatus(status: Bool, success: @escaping(Profile) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let endPoint = "engineer/\(idEngineer)/status"
        
        let params: Parameters = [
            "status": status
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        Profile.self,
                        from: data)
                    
                    Profile.shared?.online = status
                    
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errorMsg, errorCode in
            failure(errorMsg, errorCode)
        }
        
    }
    
}
