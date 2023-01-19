//
//  HistoryWallet.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 26/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct HistoryWallet: Codable {
    let statusCode: Int?
    let data: WalletStory?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct WalletStory: Codable {
    let history: [WalletMonthly]?
}

struct WalletMonthly: Codable {
    let month: String?
    let nominal: Double?
}
