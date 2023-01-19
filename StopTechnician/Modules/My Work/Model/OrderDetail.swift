//
//  OrderDetail.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 19/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct OrderDetail: Codable {
    let statusCode: Int?
    let data: Orders?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Orders: Codable {
    let id, category, subCategory: String?
    let staticPrice: Bool?
    let price: Double?
    let status, bidSession, latitude, longitude: String?
    let expiredTime, description: String?
    let media, thumbnail: String?
    let type: String?
    let totalBid: Int?
    let bidder: Bidder?
    let customer: Customer?
    
    enum CodingKeys: String, CodingKey {
        case id, category
        case subCategory = "sub_category"
        case staticPrice = "static_price"
        case price, status
        case bidSession = "bid_session"
        case latitude, longitude
        case expiredTime = "expired_time"
        case description, media, thumbnail, type
        case totalBid = "total_bid"
        case bidder, customer
    }
}

struct Bidder: Codable {
    let idBid, idBidder: Int?
    let phone, engineerName: String?
    let photo: String?
    let specializationsIcon, markerIcon: String?
    let distance: Double?
    let message: String?
    let rate, latitude, longitude, price: Double?
    let startingTime, status: String?
    
    enum CodingKeys: String, CodingKey {
        case idBid = "id_bid"
        case idBidder = "id_bidder"
        case phone
        case engineerName = "engineer_name"
        case photo
        case specializationsIcon = "specializations_icon"
        case markerIcon = "marker_icon"
        case distance, message, rate, latitude, longitude, price
        case startingTime = "starting_time"
        case status
    }
}

struct Customer: Codable {
    let id, fullname, address, email: String?
    let phone, language: String?
    let photo: String?
    let rate: Double?
}
