//
//  GSTextField.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 24/01/19.
//  Copyright © 2019 Agus Cahyono. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UILabel - Localizable
@IBDesignable class GSTextField: UITextField {
    
    @IBInspectable var placeholderArabic: String = ""
    @IBInspectable var placeholderEnglish: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.bind()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.bind()
    }
    
    
    func getText() -> String {
        return self.text ?? ""
    }
    
    func bind() {
        if GusLanguage.shared.currentLang == "ar" {
            self.placeholder = placeholderArabic
        } else{
            self.placeholder = placeholderEnglish
        }
    }
    
}
