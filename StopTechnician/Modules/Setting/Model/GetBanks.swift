//
//  GetBanks.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 03/01/19.
//  Copyright © 2019 Agus Cahyono. All rights reserved.
//

import Foundation

struct GetBanks: Codable {
    let statusCode: Int?
    let data: BankData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct BankData: Codable {
    let id, engineerID: Int?
    let accountName, accountNumber, address, city: String?
    let bank: Bank?
    
    enum CodingKeys: String, CodingKey {
        case id
        case engineerID = "engineer_id"
        case accountName = "account_name"
        case accountNumber = "account_number"
        case address, city, bank
    }
}
