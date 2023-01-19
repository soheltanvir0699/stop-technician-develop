//
//  UILabel+Extensions.swift
//  BuatBahasa
//
//  Created by Agus Cahyono on 11/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UILabel - Localizable
@IBDesignable class GSLabel: UILabel {
    
    @IBInspectable var arabicTranslation: String = ""
    @IBInspectable var defaultTranslation: String = ""
    
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
            self.text = arabicTranslation
        } else{
            self.text = defaultTranslation
        }
    }
    
}
