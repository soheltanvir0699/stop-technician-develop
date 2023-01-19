//  
//  HistoryModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct History: Codable {
    let statusCode: Int?
    let data: [Histories]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Histories: Codable {
    let id, category: String?
    let price: Double?
    let description: String?
    let totalBid: Int?
    let status, createdAt, type: String?
    let staticPrice: Bool?
    let thumbnail, media: String?
    let isRated: Bool?
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
        case bidSession = "bid_session"
    }
}
