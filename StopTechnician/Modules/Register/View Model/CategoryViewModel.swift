//
//  CategoryViewModel.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation

class CategoryViewModel {
    
    private let service: RegisterServiceProtocol
    
    private var model: [Specialize] = [Specialize]() {
        didSet {
            self.finishGetCategory?()
        }
    }
    
    // update loading status
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    // show alert message
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    // selected model
    var selectedObject: RegisterModel?
    
    func countSection() -> Int {
        return self.model.count
    }
    
    func buildSection(index: Int) -> Specialize? {
        return self.model[index]
    }
    
    // closure callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var finishGetCategory: (() -> ())?
    
    init(withRegister serviceProtocol: RegisterServiceProtocol = RegisterService() ) {
        self.service = serviceProtocol
    }
    
    func didGetCategory() {
        self.isLoading = true
        self.service.getCategories(completion: { categories in
            
            self.isLoading = false
            if let data = categories.data {
                self.model = data
            }
           
        }) { errormsg, errorCode  in
            self.isLoading = false
            self.alertMessage = errormsg
        }
    }
    
}

extension CategoryViewModel {
    
}
