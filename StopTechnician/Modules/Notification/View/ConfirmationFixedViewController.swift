//
//  ConfirmationFixedViewController.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import CollieGallery

class ConfirmationFixedViewController: StopAppBaseView {

    @IBOutlet weak var tableView: SDStateTableView!
    
    var pictures = [CollieGalleryPicture]()
    var notifViewModel = NotificationViewModel()
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(HeaderBid.build(), forCellReuseIdentifier: "header")
        self.tableView.register(CommentsView.build(), forCellReuseIdentifier: "comments")
        
        self.bindViewModel()
        self.tableView.es.addPullToRefresh {
            self.bindViewModel()
            self.tableView.es.stopPullToRefresh()
        }
        
    }
    
    func bindViewModel() {
        
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
                
            })
        }
        
        //---------
        self.notifViewModel.showAlertClosure = {
            self.alertMessage("", message: self.notifViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.notifViewModel.notificationOrder(self.id) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
        self.setNavigationBar("", color: "#F5FAFE")
    }
    
}

extension ConfirmationFixedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! HeaderBid
            
            if let getData = self.notifViewModel.orderDetail {
                cell.headerOrderDetail(getData)
                
                let picture = CollieGalleryPicture(url: getData.thumbnail ?? "")
                pictures.append(picture)
                
            }
            
            
            let gestureImage = UITapGestureRecognizer(target: self, action: #selector(self.didZoomImage(_:)))
            cell.imagePlaceholder.isUserInteractionEnabled = true
            cell.imagePlaceholder.addGestureRecognizer(gestureImage)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmfixed", for: indexPath) as! ConfirmationFixedViewCell
            
            if let getData = self.notifViewModel.orderDetail {
                cell.categoryName.text = getData.category
                cell.clientMessage.text = getData.description
                
//                if getData.status != "open" {
//                    cell.btnAccept.isHidden = true
//                    cell.btnReject.isHidden = true
//                } else {
//                    cell.btnAccept.isHidden = false
//                    cell.btnReject.isHidden = false
//                }
            }
            
            
            cell.btnAccept.addTarget(self, action: #selector(self.didAcceptOrder(_:)), for: .touchUpInside)
            cell.btnReject.addTarget(self, action: #selector(self.didRejectOrder(_:)), for: .touchUpInside)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func didAcceptOrder(_ sender: UIButton) {
        self.notifViewModel.acceptOrder(self.id) { alert in
            self.alertMessage(GusSetLanguage.getLanguage(key: "global.success.alert.title"), message: alert, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func didRejectOrder(_ sender: UIButton) {
        self.notifViewModel.rejectOrder(self.id) { alert in
            self.alertMessage("", message: alert, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func didZoomImage(_ sender: UITapGestureRecognizer) {
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
    }
    
}
