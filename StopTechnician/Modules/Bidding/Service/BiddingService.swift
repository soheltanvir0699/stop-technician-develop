//  
//  BiddingService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire

class BiddingService: BiddingServiceProtocol {
    // Call protocol function
    
    func didSubmitOrder(id: String, success: @escaping () -> Void, failure: @escaping (String, Int) -> Void) {
        
        let endPoint = "engineer/bid/\(id)/submit"
        
        let parameters: Parameters = [
            "message" : Bidding.shared.messageBid,
            "price"    : Bidding.shared.priceBid,
            "starting_time": Bidding.shared.startingTimeBid
        ]
        
        APIManager.request(
            endPoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                DispatchQueue.main.async {
                    success()
                }
                
        }) { errormsg, errorCode in
            failure(errormsg, errorCode)
        }
        
    }
    
    func detailBidContent(id: String, success: @escaping (OrderDetail) -> Void, failure: @escaping (String, Int) -> Void) {
        
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
