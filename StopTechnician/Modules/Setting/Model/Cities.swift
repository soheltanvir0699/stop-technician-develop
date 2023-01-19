//
//  Cities.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 13/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

import Foundation

struct Cities: Codable {
    let statusCode: Int?
    let data: [String]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}
