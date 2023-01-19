//
//  MenuViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class MenuViewController: StopAppBaseView, UITableViewDelegate, UITableViewDataSource {
    
    let menu = [
        GusSetLanguage.getLanguage(key: "menu.mywork.replace"),
        GusSetLanguage.getLanguage(key: "menu.notification.replace"),
        GusSetLanguage.getLanguage(key: "menu.history.replace"),
        GusSetLanguage.getLanguage(key: "menu.wallet.replace"),
        GusSetLanguage.getLanguage(key: "menu.setting.replace"),
        GusSetLanguage.getLanguage(key: "menu.logout.replace")]
    let menuIcon = [#imageLiteral(resourceName: "workIcon"), #imageLiteral(resourceName: "notifications-button"), #imageLiteral(resourceName: "folder"), #imageLiteral(resourceName: "wallet"), #imageLiteral(resourceName: "settings-work-tool"), #imageLiteral(resourceName: "logoutIcon")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MenuCell.createNib(), forCellReuseIdentifier: "menu")
        tableView.register(HeaderViewCell.createNib(), forCellReuseIdentifier: "header")
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: "F5FAFE")
        tableView.isScrollEnabled = false
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    @IBAction func didFacebookTap(_ sender: UIButton) {
        if let url = URL(string: Profile.shared?.facebook ?? "") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func didTapLinkedin(_ sender: UIButton) {
        if let url = URL(string: Profile.shared?.linkedin ?? "") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func didTapTwitter(_ sender: UIButton) {
        if let url = URL(string: Profile.shared?.twitter ?? "") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func didTapInstagram(_ sender: UIButton) {
        if let url = URL(string: Profile.shared?.instagram ?? "") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.transparentBar()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let viewController = UIStoryboard.init(name: "SettingView", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationSetting")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let viewController = UIStoryboard.init(name: "MyWorkView", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyWorkViewNavigation")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let viewController = UIStoryboard.init(name: "NotificationView", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationNotification")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let viewController = UIStoryboard.init(name: "HistoryView", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationHistory")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.row ==  4 {
            let viewController = UIStoryboard.init(name: "WalletView", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationWallet")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.row == 5 {
            let viewController = UIStoryboard.init(name: "SettingView", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationSetting")
            self.present(viewController, animated: true, completion: nil)
        }
        
        if indexPath.row == menu.count {

            self.confirmationMessage(GusSetLanguage.getLanguage(key: "global.button.confirmation"), message: GusSetLanguage.getLanguage(key: "logout.alert.confirm.title")) {
                StopAppBaseView.logoutApp()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as? MenuCell else { return UITableViewCell() }
        
        guard let header = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as? HeaderViewCell else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            header.setupHeader()
            return header
        } else {
            
            cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "F5FAFE")
            
            cell.menuIcon.image = menuIcon[indexPath.row - 1]
            cell.menuTitle.text = menu[indexPath.row - 1]
            
            cell.menuBadge.isHidden = true
            
            if let notifCount = Profile.shared?.notificationCount {
                if notifCount > 0 {
                    if indexPath.row == 1 {
                        cell.menuBadge.text = "\(notifCount)"
                        cell.menuBadge.isHidden = false
                    }
                }
            }
            
            if let biddingCount = Profile.shared?.bidCount {
                if biddingCount > 0 {
                    if indexPath.row == 2 {
                        cell.menuBadge.text = "\(biddingCount)"
                        cell.menuBadge.isHidden = false
                    }
                }
            }
            return cell
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .automatic)
    }
    
}
