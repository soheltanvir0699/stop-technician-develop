//  
//  NotificationService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class NotificationService: NotificationServiceProtocol {
    
    /// GET NOTIFICATION
    ///
    /// - Parameters:
    ///   - offset: offsets
    ///   - fetchType: fetch type
    ///   - success: success response
    ///   - failure: failure response
    func getNotification(offset: Int, fetchType: StopfetchType, success: @escaping (Notifications) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        
        let url = "engineer/\(idEngineer)/notifications"
        
        let params: Parameters = [
            "offset": offset,
            "limit": 10
        ]
        
        APIManager.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                // mapping data
                do {
                    let decoded = try JSONDecoder().decode(Notifications.self, from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errorMsg, errorCode in
            failure(errorMsg, errorCode)
        }
        
    }
    
    
    func notifIsRead(notifid: Int, completion: @escaping () -> Void) {
       
        let idEngineer = Profile.shared?.id ?? 0
        let endPoint = " engineer/\(idEngineer)/notifications/\(notifid)"
        
        let parameters: Parameters = [:]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                completion()
                
        }) { _, _ in
            completion()
        }
        
    }
    
    func getOrderDetail(id: String, success: @escaping (OrderDetail) -> Void, failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/\(id)"
        
        let parameters: Parameters = [:]
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(
                            OrderDetail.self,
                            from: data)
                        success(decoded)
                    } catch _ {
                        failure(APIManager.generateRandomError(), 0)
                    }
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func acceptOrder(id: String, success: @escaping (APISuccess) -> Void, failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/\(id)/accept"
        
        let parameters: Parameters = [:]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(
                            APISuccess.self,
                            from: data)
                        success(decoded)
                    } catch _ {
                        failure(APIManager.generateRandomError(), 0)
                    }
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func rejectOrder(id: String, success: @escaping (APISuccess) -> Void, failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/\(id)/reject"
        
        let parameters: Parameters = [:]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(
                            APISuccess.self,
                            from: data)
                        success(decoded)
                    } catch _ {
                        failure(APIManager.generateRandomError(), 0)
                    }
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
}
