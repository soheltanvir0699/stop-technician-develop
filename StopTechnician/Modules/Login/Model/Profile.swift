//  
//  SocialLoginModel.swift
//  StopApp
//
//  Created by Agus Cahyono on 30/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import KeychainAccess


struct Profile: Codable {
    
    let statusCode: Int?
    let data: User?
    
    static var shared: User? {
        didSet {
            let keychain = Keychain(service: APIEnvironment.serviceName)
            if let userOptional = shared {
                keychain["profile"] = self.json(from: userOptional)
            }
        }
    }

    static func json(from object: User) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(object)
        return String(data: data, encoding: String.Encoding.utf8)!
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct User: Codable {
    let id: Int?
    let name, email, address, specialized: String?
    let experience: Int?
    let referralCode, phone: String?
    let latitude, longitude: Double?
    let photo: String?
    let specializationsIcon, markerIcon: String?
    let rate: Int?
    var online: Bool?
    var lang: String?
    var token: String?
    var notificationCount, bidCount: Int?
    var facebook, linkedin, twitter, instagram: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, address, specialized, experience
        case referralCode = "referral_code"
        case phone, latitude, longitude, photo
        case specializationsIcon = "specializations_icon"
        case markerIcon = "marker_icon"
        case rate, token
        case lang
        case online
        case notificationCount = "notification_count"
        case bidCount = "bid_count"
        case facebook, linkedin, twitter, instagram
    }
}
