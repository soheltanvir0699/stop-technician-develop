//
//  Int+Extension.swift
//  WWCalendarTimeSelector
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Wonder. All rights reserved.
//

import UIKit

public extension Int {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * .pi / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / .pi) }
}
