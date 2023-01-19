//  
//  WalletServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol WalletServiceProtocol {
    
    func getWalletHistory(offset: Int, success: @escaping(Wallets) -> (), failure: @escaping(String, Int) -> ())
    
    func monthlyWalletHistory(offset: Int, success: @escaping(HistoryWallet) -> (), failure: @escaping(String, Int) -> ())
    
}
