//  
//  MyWorkServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol MyWorkServiceProtocol {
    
    
    /// GET MY WORK IN PROGRESS
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response
    func getMyWork(success: @escaping(MyWork) -> (), failure: @escaping(String, Int) -> ())
    
    /// GET MY BIDS IN PROGRESS
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response
    func getMyBids(success: @escaping(MyWork) -> (), failure: @escaping(String, Int) -> ())

    
    /// ORDER DETAIL
    ///
    /// - Parameters:
    ///   - id: order id
    ///   - success: succes response
    ///   - failure: failure response
    func getOrderDetail(id: String, success: @escaping(OrderDetail) -> Void, failure: @escaping(String, Int) -> ())
    
    
    /// COMPLETE WORK
    ///
    /// - Parameters:
    ///   - id: id order
    ///   - success: success response
    ///   - failure: failure response
    func completeWork(id: String, success: @escaping(APISuccess) -> Void, failure: @escaping(String, Int) -> ())
    
    
    func rateOrder(id: String, rate: Double, message: String, success: @escaping(APISuccess) -> Void, failure: @escaping(String, Int) -> ())
}

