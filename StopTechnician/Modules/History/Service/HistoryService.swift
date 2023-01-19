//  
//  HistoryService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class HistoryService: HistoryServiceProtocol {
    
    func getHistory(offset: Int, success: @escaping (History) -> (), failure: @escaping (String, Int) -> ()) {
        
        let url = "engineer/bid/history"
        
        let params: Parameters = [
            "limit" : 10,
            "offset": offset
        ]
        
        APIManager.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                do {
                    let decoded = try JSONDecoder().decode(History.self, from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errorMsg, errorCode  in
            failure(errorMsg, errorCode)
        }
        
    }
    
    
    func detailHistory(id: String, success: @escaping (OrderDetail) -> Void, failure: @escaping (String, Int) -> ()) {
        
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
    
}
