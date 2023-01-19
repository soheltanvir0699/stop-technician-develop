//  
//  HomeView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class HomeView: StopAppBaseView {
    
    @IBOutlet weak var tableview: SDStateTableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var todayTotalWording: UILabel!
    @IBOutlet weak var totalServices: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    
    
    var SCREEN_WIDTH = UIScreen.main.bounds.size.width
    var SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    fileprivate let switchStatus = UISwitch(frame: .zero)
    fileprivate let switchStatusLabel = UILabel(frame: .zero)
    fileprivate let logohome = UIImageView(frame: .zero)
    fileprivate let burgermenu = UIButton(frame: .zero)
    fileprivate let spaceview = UIView(frame: .zero)
    
    var homeViewModel = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableview.estimatedRowHeight = 60
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.tableHeaderView = headerView
        self.tableview.backgroundColor = .white
        
        self.tableview.register(JobViewCell.build(), forCellReuseIdentifier: "newjob")
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        self.addNavbarMenu()
        self.buildBurgerMenu()
        
        self.tableview.es.addPullToRefresh {
            self.bindViewModel()
            self.tableview.es.stopPullToRefresh()
        }
        
        
        self.bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openMyOrder), name: Notification.Name("openmyorder"), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar("", color: "#FFFFFF")
    }
    
    fileprivate func bindViewModel() {
        
        self.homeViewModel.updateLoadingStatus = { [weak self] in
            if self?.homeViewModel.statusLoading ?? false {
                self?.showLoading()
            } else {
                self?.dismissLoading()
            }
        }
        
        self.homeViewModel.updateLoading = { [weak self] in
            if self?.homeViewModel.isLoading ?? false {
                self?.tableview.reloadData()
                self?.tableview.showLoader()
            } else {
                self?.tableview.reloadData()
                self?.tableview.hideLoader()
            }
        }
        
        //---------
        self.homeViewModel.showAlertClosure = { [weak self] in
            self!.alertMessage(GusSetLanguage.getLanguage(key: "global.error.alert.title"), message: self?.homeViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.homeViewModel.getJobsToday()
        
        self.homeViewModel.summaryloaded = { [weak self] in
            if self?.homeViewModel.countJobs() == 0 {
                self?.tableview.setState(
                    .withImage(image: "noJobs",
                               title: GusSetLanguage.getLanguage(key: "home.jobs.empty.title"),
                               message: GusSetLanguage.getLanguage(key: "home.jobs.empty.title") ))
            } else {
                self?.tableview.setState(.dataAvailable)
            }
            
            if let getServices = self?.homeViewModel.currentJob?.counter, let getAmount = self?.homeViewModel.currentJob?.nominal {
                self?.totalServices.text = GusSetLanguage.getLanguage(key: "home.jobs.total.services", values: ["\(getServices)"])
                self?.totalAmount.text = "$\(getAmount)"
            } else {
                self?.totalServices.text = GusSetLanguage.getLanguage(key: "home.jobs.total.services", values: ["0"])
                self?.totalAmount.text = "$0"
            }
            
            
            self?.tableview.reloadData()
            
        }
        
    }
    
    @objc func openMyOrder() {
        DispatchQueue.main.async {
            let viewController = UIStoryboard.init(name: "MyWorkView", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyWorkViewNavigation")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func buildBurgerMenu() {
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationTransformScaleFactor = 1
        SideMenuManager.default.menuWidth = 320
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.init().menuEnableSwipeGestures = true
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }
    
    fileprivate func addNavbarMenu() {
        
        let checkStatus = Profile.shared?.online ?? false
        
        if checkStatus {
            switchStatus.isOn = true
            switchStatusLabel.text = GusSetLanguage.getLanguage(key: "home.status.user.online")
        } else {
            switchStatus.isOn = false
            switchStatusLabel.text = GusSetLanguage.getLanguage(key: "home.status.user.offline")
        }
        
        switchStatus.onTintColor = UIColor.hexStringToUIColor(hex: "#E42F38")
        switchStatus.addTarget(self, action: #selector(self.switchToggled(_:)), for: .valueChanged)
        let switch_display = UIBarButtonItem(customView: switchStatus)
        
       
        switchStatusLabel.font = UIFont.init(name: "CircularStd-Book", size: 16)
        switchStatusLabel.textColor = UIColor.hexStringToUIColor(hex: "#273D52")
        let switch_label_display = UIBarButtonItem(customView: switchStatusLabel)
        navigationItem.rightBarButtonItems = [switch_display, switch_label_display]
        
        switchStatus.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        switchStatus.frame.center.y = 20
        
        logohome.image = #imageLiteral(resourceName: "logo_home")
        let logohomedisplay = UIBarButtonItem(customView: logohome)
        
        burgermenu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        let burgermenudisplay = UIBarButtonItem(customView: burgermenu)
        burgermenu.addTarget(self, action: #selector(self.didopenmenu(_:)), for: .touchUpInside)
        
        let spaceviewdisplay = UIBarButtonItem(customView: spaceview)
        
        navigationItem.leftBarButtonItems = [burgermenudisplay, spaceviewdisplay, logohomedisplay]
        
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            self.switchStatusLabel.text = GusSetLanguage.getLanguage(key: "home.status.user.online")
            self.homeViewModel.switchStatus(status: true, completion: {})
        }
        else{
            self.switchStatusLabel.text =  GusSetLanguage.getLanguage(key: "home.status.user.offline")
            self.homeViewModel.switchStatus(status: false, completion: {})
        }
    }
    
    @objc func didopenmenu(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "openmenu", sender: self)
    }
    
}

