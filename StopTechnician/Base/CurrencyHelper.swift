//
//  CurrencyHelper.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 11/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

extension Double {
    
    var replaceCurrenyLocal: String {
        let doubleValue = self
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ar_DZ")
        
        if self == 0 {
            return "SAR 0"
        } else {
            let returnValue = formatter.string(from: NSNumber(value: doubleValue))! + " "
            return "SAR " + returnValue
        }
    }
    
    
}
