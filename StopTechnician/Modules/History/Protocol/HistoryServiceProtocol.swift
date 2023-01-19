//  
//  HistoryServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol HistoryServiceProtocol {
    
    /// Get History
    ///
    /// - Parameters:
    ///   - success: Success Response
    ///   - failure: Failure Response
    /// - Returns: retuen failure
    func getHistory(offset: Int, success: @escaping(History) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// DETAIL HISTORY
    ///
    /// - Parameters:
    ///   - id: id order
    ///   - success: success response
    ///   - failure: failure response
    func detailHistory(id: String, success: @escaping(OrderDetail) -> Void, failure: @escaping(String, Int) -> ())
    
}
