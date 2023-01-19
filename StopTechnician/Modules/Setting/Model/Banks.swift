//
//  Banks.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 13/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

import Foundation

struct Banks: Codable {
    let statusCode: Int?
    let data: [Bank]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct Bank: Codable {
    let id: Int?
    let name: String?
}
