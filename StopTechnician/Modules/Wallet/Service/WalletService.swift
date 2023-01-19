//  
//  WalletService.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire


class WalletService: WalletServiceProtocol {
    
    func getWalletHistory(offset: Int, success: @escaping (Wallets) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let url = "engineer/\(idEngineer)/wallet"
        
        let params: Parameters = [
            "limit" : 10,
            "offset": offset,
            "type": "daily"
        ]
        
        APIManager.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(Wallets.self, from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errorMsg, errorCode  in
            failure(errorMsg, errorCode)
        }
        
    }
    
    func monthlyWalletHistory(offset: Int, success: @escaping (HistoryWallet) -> (), failure: @escaping (String, Int) -> ()) {
        
        let idEngineer = Profile.shared?.id ?? 0
        let url = "engineer/\(idEngineer)/wallet"
        
        let params: Parameters = [
            "limit" : 10,
            "offset": offset,
            "type": "monthly"
        ]
        
        APIManager.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: APIManager.requestHeader(),
            completion: { data in
                
                do {
                    let decoded = try JSONDecoder().decode(HistoryWallet.self, from: data)
                    success(decoded)
                } catch _ {
                    failure(APIManager.generateRandomError(), 0)
                }
                
        }) { errorMsg, errorCode  in
            failure(errorMsg, errorCode)
        }
        
    }
    
}
