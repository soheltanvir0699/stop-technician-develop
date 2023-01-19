//  
//  BiddingServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol BiddingServiceProtocol {
    // Add you own protocol function for a BiddingServiceProtocol.
    
    
    /// DID SUBMIT ORDER
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response
    func didSubmitOrder(id: String, success: @escaping() -> Void, failure: @escaping(String, Int) -> Void)
    
    
    /// DETAIL BID CONTENT
    ///
    /// - Parameters:
    ///   - id: id bid content
    ///   - success: success response
    ///   - failure: failure response
    func detailBidContent(id: String, success: @escaping(OrderDetail) -> Void, failure: @escaping(String, Int) -> Void)
    
}
