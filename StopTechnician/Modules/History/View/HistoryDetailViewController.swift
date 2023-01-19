//
//  HistoryDetailViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import CollieGallery

class HistoryDetailViewController: StopAppBaseView {

    @IBOutlet weak var tableView: SDStateTableView!
    
    var pictures = [CollieGalleryPicture]()
    var id: String = ""
    var historyViewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(HeaderBid.build(), forCellReuseIdentifier: "header")
        
        self.bindViewModel()
        self.tableView.es.addPullToRefresh {
            self.bindViewModel()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func bindViewModel() {
        
        self.historyViewModel.updateLoadingStatus = {
            if self.historyViewModel.isLoading {
                self.tableView.reloadData()
                self.tableView.showLoader()
            } else {
                self.tableView.reloadData()
                self.tableView.hideLoader()
            }
        }
        
        self.historyViewModel.internetConnectionStatus = {
            self.setInternetErrorState(self.tableView, completion: {
                
            })
        }
        
        self.historyViewModel.serverErrorStatus = {
            self.setServerErrorState(self.tableView, completion: {})
        }
        
        //---------
        self.historyViewModel.showAlertClosure = {
            self.alertMessage("", message: self.historyViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.historyViewModel.orderWithDetail(self.id) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar("", color: "F5FAFE", titleColor: "FFFFFF")
        self.navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: "F5FAFE")
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
    }

}

extension HistoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! HeaderBid
            
            if let getData = self.historyViewModel.orderDetail {
                cell.headerOrderDetail(getData)
                
                let picture = CollieGalleryPicture(url: getData.thumbnail ?? "")
                pictures.append(picture)
                
            }
            
            let gestureImage = UITapGestureRecognizer(target: self, action: #selector(self.didZoomImage(_:)))
            cell.imagePlaceholder.isUserInteractionEnabled = true
            cell.imagePlaceholder.addGestureRecognizer(gestureImage)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! InfoBiddingCell
            
            if let getData = self.historyViewModel.orderDetail {
                cell.setupInfoOrderWorking(getData)
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ratereview", for: indexPath) as! RateReviewCell
            
            if let getData = self.historyViewModel.orderDetail?.customer {
                cell.setupCustomer(getData)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func didZoomImage(_ sender: UITapGestureRecognizer) {
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
    }
    
}
