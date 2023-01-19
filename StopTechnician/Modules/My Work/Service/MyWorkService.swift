//  
//  MyWorkService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class MyWorkService: MyWorkServiceProtocol {
    
    
    /// GET MY WORK
    ///
    /// - Parameters:
    ///   - success: <#success description#>
    ///   - failure: <#failure description#>
    func getMyWork(success: @escaping (MyWork) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/inprogress"
        
        let parameters: Parameters = [:]
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        MyWork.self,
                        from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    /// GET MY BIDS
    ///
    /// - Parameters:
    ///   - success: <#success description#>
    ///   - failure: <#failure description#>
    func getMyBids(success: @escaping (MyWork) -> (), failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/open"
        
        let parameters: Parameters = [:]
        
        APIManager.request(
            endPoint,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(
                        MyWork.self,
                        from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    
    /// DETAIL ORDER
    ///
    /// - Parameters:
    ///   - id: id order
    ///   - success: success response
    ///   - failure: failure response
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
    
    func completeWork(id: String, success: @escaping (APISuccess) -> Void, failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/\(id)/complete"
        
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
    
    func rateOrder(id: String, rate: Double, message: String, success: @escaping (APISuccess) -> Void, failure: @escaping (String, Int) -> ()) {
        
        let endPoint = "engineer/bid/\(id)/rate"
        
        let parameters: Parameters = [
            "rate": rate,
            "message": message
        ]
        
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
