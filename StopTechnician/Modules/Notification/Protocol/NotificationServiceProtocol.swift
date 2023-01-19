//  
//  NotificationServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol NotificationServiceProtocol {
    
    
    /// GET NOTIFICATION LIST
    ///
    /// - Parameters:
    ///   - offset: offset set
    ///   - fetchType: fetch type
    ///   - success: success response
    ///   - failure: failure response
    /// - Returns: return
    func getNotification(offset: Int, fetchType: StopfetchType, success:@escaping (Notifications) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// UPDATE STATUS READ NOTIFICATION
    ///
    /// - Parameters:
    ///   - notifid: notif id
    ///   - completion: completion
    /// - Returns: return
    func notifIsRead(notifid: Int, completion: @escaping() -> Void)
    
    
    /// GET NOTIFICATION ORDER DETAIL
    ///
    /// - Parameters:
    ///   - id: id order
    ///   - success: success response
    ///   - failure: failure response
    func getOrderDetail(id: String, success: @escaping(OrderDetail) -> Void, failure: @escaping(String, Int) -> ())
    
    
    /// ACCEPT ORDER
    ///
    /// - Parameters:
    ///   - id: id order
    ///   - success: success response
    ///   - failure: faiure response
    func acceptOrder(id: String, success: @escaping(APISuccess) -> Void, failure: @escaping(String, Int) -> ())
    
    /// REJECT ORDER
    ///
    /// - Parameters:
    ///   - id: id order
    ///   - success: success response
    ///   - failure: faiure response
    func rejectOrder(id: String, success: @escaping(APISuccess) -> Void, failure: @escaping(String, Int) -> ())
    
    
    
}
