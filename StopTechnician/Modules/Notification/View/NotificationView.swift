//  
//  NotificationView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import ESPullToRefresh

class NotificationView: StopAppBaseView {

    // OUTLETS HERE
    @IBOutlet weak var tableView: SDStateTableView!
    
    // VARIABLES HERE
    var notifViewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.es.addPullToRefresh {
            self.notifViewModel.getNotifications(fetchMode: .fresh) {}
            self.tableView.es.stopPullToRefresh()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    fileprivate func initViewModel() {
        
        self.notifViewModel.showAlertClosure = {
            self.alertMessage("", message: self.notifViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.notifViewModel.updateLoadingStatus = {
            if self.notifViewModel.isLoading {
                self.tableView.reloadData()
                self.tableView.showLoader()
            } else {
                self.tableView.reloadData()
                self.tableView.hideLoader()
            }
        }
        
        self.notifViewModel.internetConnectionStatus = {
            self.setInternetErrorState(self.tableView, completion: {
                self.notifViewModel.getNotifications(fetchMode: .fresh) {}
            })
        }

        self.notifViewModel.serverErrorStatus = {
            self.setServerErrorState(self.tableView, completion: {
                self.notifViewModel.getNotifications(fetchMode: .fresh) {}
            })
        }
        
        
        self.notifViewModel.getNotifications(fetchMode: .fresh) {
            if self.notifViewModel.count == 0 {
                self.tableView.setState(
                    .withImage(image: "noNotification",
                               title: GusSetLanguage.getLanguage(key: "notification.empty.title"),
                               message: GusSetLanguage.getLanguage(key: "notification.empty.message")))
            } else {
                self.tableView.setState(.dataAvailable)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar(GusSetLanguage.getLanguage(key: "menu.notification.replace"), color: "E42F38", titleColor: "FFFFFF")
        self.navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
        
        self.initViewModel()
    }
    
    @IBAction func didDismissPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NotificationView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifViewModel.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notif", for: indexPath) as! NotifViewCell
        
        if let _ = self.notifViewModel.count {
            let data = self.notifViewModel.data[indexPath.row]
            cell.setupNotifications(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = self.notifViewModel.count {
            
            let data = self.notifViewModel.data[indexPath.row]
            
            DispatchQueue.main.async {
                self.notifViewModel.readNotification(id: data.id ?? 0) {}
            }
            
            if data.type == "order" {
                let confirm = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationFixedViewController") as! ConfirmationFixedViewController
                confirm.id = data.idOrder ?? ""
                self.navigationController?.pushViewController(confirm, animated: true)
            }
        }
        
    }
    
}
