//
//  GusSetLanguage.swift
//  StopApp
//
//  Created by Agus Cahyono on 16/09/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

struct GusSetLanguage {
    
    static var languagesFiles: [String] = ["auths", "global", "menu"]
    static var tempLanguage = [NSDictionary]()
    
    /// Mendapatkan bahasa pengguna pada perangkat
    ///
    /// - returns: kode bahasa pengguna
    static func userLanguage() -> String {
        // Get active preferred language
        guard let languageCode = Locale.current.languageCode else {
            return "en"
        }
        
        return languageCode
    }
    
    /// Menyimpan bahasa yang digunakan user pada perangkat
    static func saveUserLanguage() {
        Profile.shared?.lang = GusSetLanguage.userLanguage()
    }
    
    /// Mendapatkan lokalisasi pada file .strings
    ///
    /// - Parameters:
    ///   - key: key Kunci dari kata tersebut
    ///   - values: values Nilai yang berubah-ubah pada kata tersebut
    /// - Returns: Hasil lokalisasi
    static func getLanguage(key: String, values: [String] = [String]()) -> String {
        var dictionaries = [NSDictionary]()
        var result: String = ""
        
        // Mendapatkan semua isi file .strings
        for languagesFile: String in languagesFiles {
            
            var langDefault = ""
            
            langDefault = GusLanguage.shared.currentLang
            
            let filename = Bundle.main.path(forResource: languagesFile + "." + langDefault, ofType: "strings")
            let dictionary = NSDictionary(contentsOfFile: filename!)
            
            dictionaries.append(dictionary!)
        }
        
        // Menyimpan ke dalam variabel static
        tempLanguage = dictionaries
        
        // Merubah .strings ke dalam dictionary
        for dictionary: NSDictionary in tempLanguage {
            if let theString: String = dictionary[key] as? String {
                result = theString
                break
            }
        }
        
        // Menyisipkan value
        for value: String in values {
            result = result.stringByReplacingFirstOccurrence(of: "%@", with: value)
        }
        
        return result
    }
    
}

public extension String {
    
    func stringByReplacingFirstOccurrence(of originalString: String, with replaceString: String) -> String {
        if let range = self.range(of: originalString) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
}
