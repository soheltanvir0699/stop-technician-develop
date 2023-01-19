//
//  Spesialization.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct Specialization: Codable {
    let statusCode: Int?
    let data: [Specialize]?
}

struct Specialize: Codable {
    let id: Int?
    let name: String?
    let icon: String?
}
