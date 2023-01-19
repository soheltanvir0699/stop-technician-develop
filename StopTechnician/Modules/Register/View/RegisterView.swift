//  
//  RegisterView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class RegisterView: StopAppBaseView, CategoryDelegate {
    
    @IBOutlet weak var txName: AnimatedTextInput!
    @IBOutlet weak var txFamilyName: AnimatedTextInput!
    @IBOutlet weak var txEmail: AnimatedTextInput!
    @IBOutlet weak var txExperience: AnimatedTextInput!
    @IBOutlet weak var txInvitation: AnimatedTextInput!
    
    var getName = ""
    var getFamilyName = ""
    var getEmail = ""
    var getSpecialized = 0
    var getExperience = 0
    var getInvitation = ""
    var getLatitude = 0.0
    var getLongitude = 0.0
    var getSpecializedName = ""
    
   
    
    // OUTLETS HERE
    @IBOutlet weak var buttonregister: TransitionButton! {
        didSet {
            self.buttonregister.addShadowBottom(UIColor.hexStringToUIColor(hex: "#E42F38"), height: 3.0)
            self.buttonregister.addTarget(self, action: #selector(self.didCheckRegister(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var buttoncategorized: UIButton! {
        didSet {
            buttoncategorized.addTarget(self, action: #selector(self.didChooseCategorized(_:)), for: .touchUpInside)
        }
    }
    
    // VARIABLES HERE
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: UIImage(named: "right-arrow")!)
    }
    
    func setupField() {
        self.txName.type = .standard
        self.txName.style = AuthInputStyle()
        self.txName.clearButtonMode  = .never
        
        self.txFamilyName.type = .standard
        self.txFamilyName.style = AuthInputStyle()
        self.txFamilyName.clearButtonMode  = .never
        
        self.txEmail.type = .email
        self.txEmail.style = AuthInputStyle()
        self.txEmail.clearButtonMode  = .never
        
        self.txExperience.type = .numeric
        self.txExperience.style = AuthInputStyle()
        self.txExperience.clearButtonMode  = .never
        
        self.txInvitation.type = .standard
        self.txInvitation.style = AuthInputStyle()
        self.txInvitation.clearButtonMode  = .never
        
    }
    
    @objc func didPreviousBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func didCheckRegister(_ sender: TransitionButton) {
        let fullname    = self.txName.text ?? ""
        let familyname  = self.txFamilyName.text ?? ""
        let email       = self.txEmail.text ?? ""
        let experience  = self.txExperience.text ?? ""
        let invitation  = self.txInvitation.text ?? ""
        
        if fullname.isEmpty {
            self.txName.show(error: GusSetLanguage.getLanguage(key: "global.alert.name.empty"))
        } else if familyname.isEmpty {
            self.txName.show(error: GusSetLanguage.getLanguage(key: "global.alert.familyname.empty"))
        } else if email.isEmpty {
            self.txEmail.show(error: GusSetLanguage.getLanguage(key: "global.alert.email.empty"))
        } else if !email.isValidEmail() {
            self.txEmail.show(error: GusSetLanguage.getLanguage(key: "global.alert.email.invalid"))
        } else if experience.isEmpty {
            self.txEmail.show(error: GusSetLanguage.getLanguage(key: "global.alert.experience.empty"))
        } else if self.getSpecialized == 0 {
            self.alertMessage(GusSetLanguage.getLanguage(key: "global.error.alert.title"), message: GusSetLanguage.getLanguage(key: "global.alert.specialized.empty"))
        } else {
            
            // field variables
            self.getName            = fullname
            self.getFamilyName      = familyname
            self.getEmail           = email
            self.getExperience      = Int(experience) ?? 0
            self.getInvitation      = invitation
            
            self.performSegue(withIdentifier: "checkphone", sender: self)
        }
        
    }
    
    @objc func didChooseCategorized(_ sender: UIButton) {
        
        let popup = ServiceCategoryViewController.build {
            
        }
        
        popup.delegate = self
        
        let dialog = SBCardPopupViewController(contentViewController: popup)
        dialog.show(onViewController: self)
    }
    
    func didSelectedCategory(id: Int, _ name: String) {
        self.getSpecialized = id
        self.buttoncategorized.setTitle(name, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkphone" {
            let destination = segue.destination as! PhoneNumberViewController
            
            destination.getName         = self.getName
            destination.getFamilyName   = self.getFamilyName
            destination.getEmail        = self.getEmail.lowercased()
            destination.getSpecialized  = self.getSpecialized
            destination.getExperience   = self.getExperience
            destination.getInvitation   = self.getInvitation
            destination.getLatitude     = self.getLatitude
            destination.getLongitude    = self.getLongitude
            
        }
    }
    
}
