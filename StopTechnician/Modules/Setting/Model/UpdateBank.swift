//
//  UpdateBank.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 05/01/19.
//  Copyright © 2019 Agus Cahyono. All rights reserved.
//

import Foundation


struct UpdateBank: Codable {
    let statusCode: Int?
    let data: UpdateBankData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct UpdateBankData: Codable {
    let data: BankDataUpdate?
    let message: String?
}

struct BankDataUpdate: Codable {
    let id, engineerID, bankID: Int?
    let accountName, accountNumber, address, city: String?
    let deletedAt, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case engineerID = "engineer_id"
        case bankID = "bank_id"
        case accountName = "account_name"
        case accountNumber = "account_number"
        case address, city
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
