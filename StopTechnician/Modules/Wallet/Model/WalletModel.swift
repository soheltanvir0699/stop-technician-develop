//  
//  WalletModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct Wallets: Codable {
    let statusCode: Int?
    let data: Wallet?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Wallet: Codable {
    let history: [WalletHistory]?
    let amount: Double?
}

struct WalletHistory: Codable {
    let date: String?
    let activity: [WalletActivity]?
}

struct WalletActivity: Codable {
    
    let subCategory: String?
    let icon: String?
    let price: Double?
    let staticPrice: Bool?
    let paymentMethod: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case subCategory = "sub_category"
        case icon, price
        case staticPrice = "static_price"
        case paymentMethod = "payment_method"
        case type
    }
}
