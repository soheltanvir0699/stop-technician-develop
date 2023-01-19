//
//  APIEnvironment.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

enum APIEnvironment {
    case staging
    case production
}


extension APIEnvironment {
    
    static var baseURL = ""
    static let serviceName: String  = "ayman.stopapp"
    
    static var environment: APIEnvironment = .staging {
        didSet {
            if environment == .staging {
                APIEnvironment.stagingEnv()
            } else if environment == .production {
                APIEnvironment.prodEnv()
            }
        }
    }
    
    static func stagingEnv() {
        APIEnvironment.baseURL = "https://backend.stopapp.me/api/v1"
    }
    
    static func prodEnv() {
        APIEnvironment.baseURL = "https://backend.stopapp.me/api/v1"
    }
    
}
