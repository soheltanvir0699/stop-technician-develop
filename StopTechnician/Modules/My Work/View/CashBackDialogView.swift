//
//  CashBackDialogView.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class CashBackDialogView: StopAppBaseView, SBCardPopupContent {
    
    var popupViewController: SBCardPopupViewController?
    
    let allowsTapToDismissPopupCard = true
    let allowsSwipeToDismissPopupCard = true
    
    @IBOutlet weak var titleDialog: UILabel!
    @IBOutlet weak var messageDialog: UILabel!
    
    var cashbackTitle = ""
    var cashbackMessage = ""
    
    static func build(_ title: String,
                      message: String) -> CashBackDialogView {
        
        let storyboard = UIStoryboard(name: "BiddingView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CashBackDialogView") as! CashBackDialogView
        
        viewController.cashbackTitle = title
        viewController.cashbackMessage = message
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleDialog.text = cashbackTitle
        self.messageDialog.text = cashbackMessage
        
    }
    
}
