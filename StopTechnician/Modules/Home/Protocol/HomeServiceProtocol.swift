//  
//  HomeServiceProtocol.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

protocol HomeServiceProtocol {
    
    
    /// GET JOBS TODAY
    ///
    /// - Parameters:
    ///   - success: success response
    ///   - failure: failure response with error message and error code
    func getJobsToday(success: @escaping(Summary) -> (), failure: @escaping(String, Int) -> ())
    
    
    /// Switch Status User
    ///
    /// - Parameters:
    ///   - status: status bool
    ///   - success: success response
    ///   - failure: failure response
    func switchStatus(status: Bool, success: @escaping(Profile) -> (), failure: @escaping(String, Int) -> ())
    
}
