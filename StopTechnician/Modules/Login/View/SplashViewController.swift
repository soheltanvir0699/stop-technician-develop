//
//  SplashViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class SplashViewController: StopAppBaseView {

    var splashVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserToken.token().isEmpty {
            self.performSegue(withIdentifier: "chooselang", sender: self)
        } else {
            self.splashVM.loadProfile {
                self.performSegue(withIdentifier: "openhome", sender: self)
            }
        }
        
    }


}
