//
//  UserToken.swift
//  StopApp
//
//  Created by Agus Cahyono on 30/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import KeychainAccess

struct UserToken {
    
    static var keychainTokenKey = "stopapptoken.ayman"
    
    static func cachedProfile() {
        // Get data from keychain
        let keychain = Keychain(service: APIEnvironment.serviceName)
        guard let profile = keychain["profile"] else {
            return
        }
        
        let decoder = JSONDecoder()
        guard let callback = try? decoder.decode(User.self, from: profile.data(using: String.Encoding.utf8)!) else {
            return
        }
        
        Profile.shared = callback
        print("Saved profile object into shared: \(callback)")
    }
    
    
    static func token() -> String {
        
        let keychain = Keychain(service: APIEnvironment.serviceName)
        guard let theToken = keychain[keychainTokenKey] else {
            return ""
        }
        
        debugPrint("TAMPILKAN TOKEN: \(theToken)")
        return theToken
    }
    
    static func saveToken(token: String) {
        let keychain = Keychain(service: APIEnvironment.serviceName)
        keychain[keychainTokenKey] = token
        
        debugPrint("TOKEN TERSIMPAN: \(token)")
    }
    
    static func deleteProfile() {
        let keychain = Keychain(service: APIEnvironment.serviceName)
        do {
            try keychain.remove("profile")
            deleteToken()
            
//            Profile.shared = User()
        } catch (let error) {
            print("Error while trying to delete profile data: \n\(error)")
        }
    }
    
    static func deleteToken() {
        let keychain = Keychain(service: APIEnvironment.serviceName)
        do {
            try keychain.remove(keychainTokenKey)
//            Profile.shared = User()
        } catch (let error) {
            print("Error while trying to delete profile data: \n\(error)")
        }
        
        print("Delete token object from keychain")
    }
    
}
