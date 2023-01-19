//
//  InvitationCodeViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import HTCopyableLabel

class InvitationCodeViewController: StopAppBaseView {
    
    @IBOutlet weak var invitecodeLabel: HTCopyableLabel!
    @IBOutlet weak var buttonstartwork: UIButton! {
        didSet {
            buttonstartwork.addTarget(self, action: #selector(self.didTapStartWork(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.invitecodeLabel.text = Profile.shared?.referralCode ?? ""
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
    }
    
    @objc func didTapStartWork(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let storyboard = UIStoryboard.init(name: "LoginView", bundle: nil)
            let rootVC: SplashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            self.present(rootVC, animated: true, completion: nil)
        })
    }
    
}
