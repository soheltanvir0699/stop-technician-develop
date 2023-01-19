//
//  GusDateHelper.swift
//  StopApp
//
//  Created by Agus Cahyono on 16/09/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import UIKit

enum DateFormatHelpers: String {
    case Full = "dd MMMM yyyy"
    case Date = "dd"
    case Month = "MMM"
    case monthYear = "MMM yyyy"
    case Dashed = "dd-MM-yyyy"
    case Garing = "dd/MM/yyyy"
    case DashedYear = "yyyy-MM-dd"
    case ShortMonth = "dd MMM yyyy"
    case withDay = "EEEE, d MMMM yyyy"
    case onlyHoursMinute = "HH:mm"
    case dashWithHour = "dd-MM-yyyy hh:mm"
    case customOne = "E - MMM dd , yyyy"
    case timeAndDashed = "h:mm a | dd/MM/yyyy"
    case timeStamp = "yyyy-MM-dd hh:mm:ss"
}

struct GusDateHelper {
    
    /**
     Convert Date Format
     
     - parameter original: yy-MM-dd HH:mm:ss
     
     - returns: to yy-MM-dd
     */
    static func convertDateFormat(original: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: original)
        
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date!)
    }
    
//    static func convertDateOnlyFormat(original: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFormatter.date(from: original)
//        
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.string(from: date!)
//    }
    
    static func convertDateFormatWithHour(original: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: original)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date!)
    }
    
    
    static func convertTimeFormat(original: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: original)
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date!)
    }
    
    static func converttoDateFormat(original: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: original)
        return date!
    }
    
    static func toDateFormat(original: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let date = dateFormatter.date(from: original)
        return date!
    }
    
    /**
     Insert NSDate and return it into string format.
     Example: 16 Juni 2016
     
     - parameter date: date Date to be converted
     
     - returns: return value Converted value
     */
    static func convertNSDateToString(date: Date) -> String {
        return convertNSDateToString(date: date, format: .Full)
    }
    
    /**
     Insert NSDate and return it in given format.
     
     - parameter date:   date Date to be converted
     - parameter format: format Date format
     
     - returns: return value Converted value
     */
    static func convertNSDateToString(date: Date, format: DateFormatHelpers) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        let idLocale = Locale(identifier: "id_ID")
        dateFormatter.locale = idLocale as Locale?
        
        return dateFormatter.string(from: date as Date)
    }
    
    /**
     Insert date string and return it in given format.
     
     - parameter date:   date Date to be converted in string format
     - parameter format: format Date format
     
     - returns: return value Converted value
     */
    static func convertDateStringToString(date: String, format: DateFormatHelpers) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "id_ID")
        
        guard let dateObject1 = dateFormatter.date(from: date) else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "id_ID")
            
            guard let dateObject2 = dateFormatter.date(from: date) else {
                return ""
            }
            
            return convertNSDateToString(date: dateObject2, format: format)
        }
        
        return convertNSDateToString(date: dateObject1, format: format)
    }
    
    static func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .minute, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .minute, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    
    
}
