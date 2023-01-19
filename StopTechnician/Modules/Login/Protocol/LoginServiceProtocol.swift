//  
//  LoginServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol LoginServiceProtocol {
    
    func login(_ phone: String, success: @escaping(User) -> (), failure: @escaping(_ msg: String, _ errorCode: Int) -> ())
    
    func loadProfile(completion: @escaping() -> ())
    
}
