//  
//  NotificationModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct Notifications: Codable {
    let statusCode: Int?
    let data: [Notif]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Notif: Codable {
    
    let id: Int?
    let name, title, description: String?
    let read: Bool?
    let createdAt, type: String?
    let icon: String?
    let statusOrder: String?
    let staticPrice: Bool?
    let idOrder: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, title, description, read
        case createdAt = "created_at"
        case type, icon
        case statusOrder = "status_order"
        case staticPrice = "static_price"
        case idOrder = "id_order"
    }
    
}
