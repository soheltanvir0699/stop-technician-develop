//
//  StatusHelper.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 11/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import UIKit

enum StatusHelper: String {
    
    case open = "open"
    case inprogress = "in progress"
    case cancel = "cancel"
    case closed = "closed"
    case complete = "complete"
    
    static func generateColor(_ status: String) -> UIColor {
        if status == StatusHelper.open.rawValue {
            return UIColor.hexStringToUIColor(hex: "#13B632")
        } else if status == StatusHelper.inprogress.rawValue {
            return UIColor.hexStringToUIColor(hex: "#7A95EB")
        } else if status == StatusHelper.cancel.rawValue {
            return UIColor.hexStringToUIColor(hex: "#FE9B00")
        } else if status == StatusHelper.complete.rawValue {
            return UIColor.hexStringToUIColor(hex: "#FF7279")
        } else if status == StatusHelper.closed.rawValue {
            return UIColor.hexStringToUIColor(hex: "#7D8B97")
        } else {
            return UIColor.red
        }
    }
    
    static func generateWording(_ status: String) -> String {
        if status == StatusHelper.open.rawValue {
            return "Open"
        } else if status == StatusHelper.inprogress.rawValue {
            return "In Progress"
        } else if status == StatusHelper.cancel.rawValue {
            return "Cancel"
        } else if status == StatusHelper.complete.rawValue {
            return "Complete"
        } else if status == StatusHelper.closed.rawValue {
            return "Closed"
        } else {
            return "Open"
        }
    }
    
}
