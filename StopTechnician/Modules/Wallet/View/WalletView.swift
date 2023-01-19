//  
//  WalletView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class WalletView: ButtonBarPagerTabStripViewController {
    
    // VARIABLES HERE
    lazy var myWallet: MyWalletView = {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletView") as! MyWalletView
        return viewController
    }()
    
    lazy var myHisotry: MyHistoryViewController = {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyHistoryViewController") as! MyHistoryViewController
        return viewController
    }()

    override func viewDidLoad() {
        
        self.settings.style.buttonBarBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemTitleColor = UIColor.hexStringToUIColor(hex: "273D52")
        if let font = UIFont(name: "CircularStd-Medium", size: 14) {
            self.settings.style.buttonBarItemFont = font
        }
        self.settings.style.buttonBarHeight = 48
        self.settings.style.selectedBarHeight = 1
        self.settings.style.selectedBarBackgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.hexStringToUIColor(hex: "273D52")
            newCell?.label.textColor = UIColor.hexStringToUIColor(hex: "E42F38")
        }
        
        super.viewDidLoad()
        
        self.buttonBarView.layer.shadowRadius = 1.0
        self.buttonBarView.layer.shadowColor = UIColor.hexStringToUIColor(hex: "7D8B97").cgColor
        self.buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.buttonBarView.layer.shadowOpacity = 0.5
        self.buttonBarView.layer.masksToBounds = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar(GusSetLanguage.getLanguage(key: "menu.wallet.replace"), color: "#E42F38", titleColor: "#FFFFFF")
    }
    
    @IBAction func didDismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [myWallet, myHisotry]
    }
    
}


