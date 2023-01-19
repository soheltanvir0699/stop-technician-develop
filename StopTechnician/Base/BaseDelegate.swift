//
//  BaseDelegate.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

enum StopfetchType {
    case fresh
    case more
}

struct BaseDelegate {
    
    static var isReceivedNotification = false
    static var idOrder = ""
    
    static func build() {
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyBDXxkuYBXNz_KB33FLAnH2u5VziM2VsTI")
        GMSPlacesClient.provideAPIKey("AIzaSyBDXxkuYBXNz_KB33FLAnH2u5VziM2VsTI")
    }
    
}
