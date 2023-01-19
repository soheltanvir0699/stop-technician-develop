//
//  ChooseLanguageView.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 02/06/19.
//  Copyright © 2019 Agus Cahyono. All rights reserved.
//

import UIKit

class ChooseLanguageView: StopAppBaseView {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didEnglishSelected(_ sender: GSButton) {
        DispatchQueue.main.async {
            GusLanguage.shared.setLanguage(language: "Base")
            Profile.shared?.lang = "en"
            self.performSegue(withIdentifier: "open", sender: self)
        }
    }
    
    @IBAction func didArabicSelected(_ sender: GSButton) {
        DispatchQueue.main.async {
            GusLanguage.shared.setLanguage(language: "ar")
            Profile.shared?.lang = "ar"
            self.performSegue(withIdentifier: "open", sender: self)
        }
    }
    

}
