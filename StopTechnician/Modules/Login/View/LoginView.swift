//  
//  LoginView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class LoginView: StopAppBaseView {

    // OUTLETS HERE
    
    @IBOutlet var titleApp: UILabel!
    @IBOutlet weak var buttonlogin: UIButton! {
        didSet {
            self.buttonlogin.addTarget(self, action: #selector(self.didSegueLogin(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var buttonregister: UIButton! {
        didSet {
            self.buttonregister.addTarget(self, action: #selector(self.didSegueRegister(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var labelUserApp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let formattedString = NSMutableAttributedString()
        if GusLanguage.shared.currentLang == "en" {
            formattedString
                .normal(GusSetLanguage.getLanguage(key: "button.otherapp") + " " , fontSize: 14)
                .bold(GusSetLanguage.getLanguage(key: "button.userapp"), fontSize: 14)
            labelUserApp.attributedText = formattedString
        } else {
            formattedString
                .normal(GusSetLanguage.getLanguage(key: "button.userapp") + " " , fontSize: 14)
                .bold(GusSetLanguage.getLanguage(key: "button.otherapp"), fontSize: 14)
            labelUserApp.attributedText = formattedString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.transparentBar()
    }
    
    @objc func didSegueLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @objc func didSegueRegister(_ sender: UIButton) {
        let register = UIStoryboard.init(name: "RegisterView", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
        self.navigationController?.pushViewController(register, animated: true)
    }
    
}
