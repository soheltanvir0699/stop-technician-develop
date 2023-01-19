//  
//  MyWorkModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct MyWork: Codable {
    let statusCode: Int?
    let data: [Working]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Working: Codable {
    let id, category: String?
    let price: Double?
    let description: String?
    let totalBid: Int?
    let status, createdAt, type: String?
    let staticPrice: Bool?
    let thumbnail: String?
    let media: String?
    let isRated: Bool?
    let expired_time: String?
    let bidSession: String?
    
    enum CodingKeys: String, CodingKey {
        case id, category, price, description
        case totalBid = "total_bid"
        case status
        case createdAt = "created_at"
        case type
        case staticPrice = "static_price"
        case thumbnail, media
        case isRated = "is_rated"
        case expired_time
        case bidSession = "bid_session"
    }
}
