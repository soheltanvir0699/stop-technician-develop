//  
//  HomeModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct Summary: Codable {
    let statusCode: Int?
    let data: Jobs?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Jobs: Codable {
    let todayService: TodayService?
    let availableOrder: [AvailableOrder]?
    
    enum CodingKeys: String, CodingKey {
        case todayService = "today_service"
        case availableOrder = "available_order"
    }
}

struct AvailableOrder: Codable {
    let id, category: String?
    let price: Double?
    let description: String?
    let totalBid: Int?
    let status, createdAt, createdAtTime, type: String?
    let staticPrice: Bool?
    let thumbnail, media: String?
    let isRated: Bool?
    let expired_time: String?
    let bidSession: String?
    
    enum CodingKeys: String, CodingKey {
        case id, category, price, description
        case totalBid = "total_bid"
        case status
        case createdAt = "created_at"
        case createdAtTime = "created_at_time"
        case type
        case staticPrice = "static_price"
        case thumbnail, media
        case isRated = "is_rated"
        case expired_time
        case bidSession = "bid_session"
    }
}

struct TodayService: Codable {
    let counter, nominal: Int?
}
