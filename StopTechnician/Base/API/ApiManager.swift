//
//  ApiManager.swift
//  RajaOngkir
//
//  Created by Agus Cahyono on 16/04/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import Alamofire


struct APIManager {
    
    static var manager: SessionManager!
    
    /// GET FROM API
    ///
    /// - Parameters:
    ///   - url: URL API
    ///   - method: methods
    ///   - parameters: parameters
    ///   - encoding: encoding
    ///   - headers: headers
    ///   - completion: completion
    ///   - failure: failure
    static func request(_ url: String, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, completion: @escaping (_ response: Data) ->(), failure: @escaping (_ error: String, _ errorCode: Int) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        
        manager = Alamofire.SessionManager(configuration: configuration)
        
        let apiURL = APIEnvironment.baseURL + url
        debugPrint("-- URL API: \(apiURL), \n\n-- headers: \(headers), \n\n-- Parameters: \(parameters)")
        
        Alamofire.request(
            apiURL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers).responseString(
                queue: DispatchQueue.main,
                encoding: String.Encoding.utf8) { response in
                    
                    debugPrint("--\n \n CALLBACK RESPONSE: \(response)")
                    
                    if response.response?.statusCode == 200 {
                        guard let callback = response.data else {
                            failure(self.generateRandomError(), 0)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            completion(callback)
                        }
                        
                    } else if response.response?.statusCode == 401 {
                        StopAppBaseView.logoutApp()
                    } else {
                        guard let callbackError = response.data else {
                            failure(self.generateRandomError(), 0)
                            return
                        }
                        
                        do {
                            let decoded = try JSONDecoder().decode(
                                APIError.self, from: callbackError)
                            if let messageError = decoded.data?.errors?.messages, let errorCode = decoded.statusCode {
                                let messages = messageError.joined(separator: ", ")
                                failure(messages, errorCode)
                            } else {
                                failure(APIManager.generateRandomError(), 0)
                            }
                        } catch _ {
                            failure(APIManager.generateRandomError(), 0)
                        }
                    }
                    
//                    manager.session.finishTasksAndInvalidate()
        }
        
    }
    
    static func upload(_ url: String, headers: HTTPHeaders, parameters: [String: Any], images: [String: UIImage], completion: @escaping (_ response: Data) ->(), failure: @escaping (_ error: String) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        manager = Alamofire.SessionManager(configuration: configuration)
        
        let apiURL = APIEnvironment.baseURL + url
        debugPrint("URL API: \(apiURL)")
        
        manager.upload(multipartFormData: { partData in
            
            // parameters
            for (key, value) in parameters {
                partData.append(key.data(using: .utf8)!, withName: value as! String)
            }
            
            if !images.isEmpty {
                for (key, value) in images {
                    let imageData = value.jpegData(compressionQuality: 0.4)
                    partData.append(imageData!, withName: key)
                }
            }
            
            
        },
       usingThreshold: UInt64.init(),
       to: apiURL,
       method: .post,
       headers: APIManager.requestHeader()) { encodingResult in
                        
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString(
                    queue: DispatchQueue.main,
                    encoding: .utf8,
                    completionHandler: { response in
                        
                        debugPrint("RESPONSE UPLOAD: \(response)")
                        
                        if response.response?.statusCode == 200 {
                            guard let callback = response.data else {
                                failure(self.generateRandomError())
                                return
                            }
                            completion(callback)
                            
                        } else if response.response?.statusCode == 401 {
                            StopAppBaseView.logoutApp()
                        } else {
                            guard let callbackError = response.data else {
                                return
                            }
                            
                            do {
                                let decoded = try JSONDecoder().decode(
                                    APIError.self, from: callbackError)
                                if let messageError = decoded.data?.errors?.messages {
                                    let messages = messageError.joined(separator: ", ")
                                    failure(messages)
                                } else {
                                    failure(APIManager.generateRandomError())
                                }
                            } catch _ {
                                failure(APIManager.generateRandomError())
                            }
                        }
                        
                        return
                        
                })
            case .failure(let encodingError):
                
                debugPrint(encodingError)
            }
                        
        }
        
    }
    
    
    /// GENERATE RANDOM ERROR
    ///
    /// - Returns: string error randoms
    static func generateRandomError() -> String {
        return "Oops. Please reload again."
    }
    
    static func requestHeader() -> HTTPHeaders {
        
        let token = UserToken.token()
        
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)",
            "X-localization": GusLanguage.shared.currentLang,
        ]
    }
    
}
