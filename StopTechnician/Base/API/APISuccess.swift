//
//  APISuccess.swift
//  StopApp
//
//  Created by Agus Cahyono on 12/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct APISuccess: Codable {
    let statusCode: Int?
    let data: MessageSuccess?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct MessageSuccess: Codable {
    let message: String?
}
