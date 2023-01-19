//
//  APIError.swift
//  StopApp
//
//  Created by Agus Cahyono on 12/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {
    case network = "No network connection. Please connect to the internet"
    case serveroverload = "Server is overload. Please be patient"
    case permissionDenied = "You don't have permission to access this service"
}

enum ErrorCode: Int {
    case notFound       = 0
    case badRequest     = 3
    case Unauthorized   = 401
    case wrongLevel     = 403
    case internalError  = 5
    case unverified     = 4002
    case unregistered   = 422
}


struct APIError: Codable {
    let statusCode: Int?
    let data: ErrosClass?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct ErrosClass: Codable {
    let errors: Errors?
}

struct Errors: Codable {
    let code: String?
    let messages: [String]?
}

