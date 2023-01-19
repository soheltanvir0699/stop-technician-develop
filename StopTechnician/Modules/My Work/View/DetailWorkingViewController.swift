//
//  DetailWorkingViewController.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import CollieGallery
import CoreLocation
import AVKit

class DetailWorkingViewController: StopAppBaseView {
    
    @IBOutlet weak var tableView: SDStateTableView!
    
    var pictures = [CollieGalleryPicture]()
    var workViewModel = MyWorkViewModel()
    var currentLocation: CLLocation!
    
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
        
        self.workViewModel.updateLoadingStatus = {
            if self.workViewModel.isLoading {
                self.tableView.reloadData()
                self.tableView.showLoader()
            } else {
                self.tableView.reloadData()
                self.tableView.hideLoader()
            }
        }
        
        self.workViewModel.internetConnectionStatus = {
            self.setInternetErrorState(self.tableView, completion: {
                
            })
        }
        
        //---------
        self.workViewModel.showAlertClosure = {
            self.alertMessage("", message: self.workViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.workViewModel.orderWithDetail(self.id) {
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

    @objc func didCallBidder(_ sender: UIButton) {
        
        let phoneNumber = self.workViewModel.orderDetail?.customer?.phone ?? ""
        
        if phoneNumber.isEmpty {
            self.alertMessage("", message: "Phone number not found") {
                
            }
        } else {
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @IBAction func didCompleteWorking(_ sender: UIButton) {
        self.confirmationMessage(GusSetLanguage.getLanguage(key: "global.button.confirmation"), message: GusSetLanguage.getLanguage(key: "work.alert.complete.working.confirmation.msg")) {
            
            self.workViewModel.completeWork(self.id) { message in
                self.alertMessage(GusSetLanguage.getLanguage(key: "global.success.alert.title"), message: message, completion: {
                    let viewController = UIStoryboard.init(name: "MyWorkView", bundle: Bundle.main).instantiateViewController(withIdentifier: "RateReviewViewController") as! RateReviewViewController
                    
                    viewController.id = self.id
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
            }
            
        }
    }
    
    @objc func didOpenDirection(_ sender: UIButton) {
        self.performSegue(withIdentifier: "direction", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "direction" {
            
            if let navigationVC = segue.destination as? UINavigationController, let destination = navigationVC.topViewController as? DirectionFixedViewController {
                
                if let getData = self.workViewModel.orderDetail {
                    destination.getClientName       = getData.customer?.fullname ?? ""
                    destination.getClientRate       = getData.customer?.rate ?? 0
                    destination.getClientPhone      = getData.customer?.phone ?? ""
                    destination.getClientAvatar     = getData.customer?.photo ?? ""
                    destination.getClientAddress    = getData.customer?.address ?? ""
                    destination.getCategoryOrder    = getData.subCategory ?? ""
                    
                    let latitudeUser    = getData.latitude ?? "0.0"
                    let longitudeUser   = getData.longitude ?? "0.0"
                    destination.userLatitude        = Double(latitudeUser)!
                    destination.userLongitude       = Double(longitudeUser)!
                    
                    let latitudeEngineer    = getData.bidder?.latitude ?? 0.0
                    let longitudeEngineer   = getData.bidder?.longitude ?? 0.0
                    
                    destination.engineerLatitude    = latitudeEngineer
                    destination.engineerLongitude   = longitudeEngineer
                }
                
            }
            
        }
    }
    
}

extension DetailWorkingViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            
            if let getData = self.workViewModel.orderDetail {
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
            
            if let getData = self.workViewModel.orderDetail {
                cell.setupInfoOrderWorking(getData)
            }
            
            cell.buttonCall.addTarget(self, action: #selector(self.didCallBidder(_:)), for: .touchUpInside)
            cell.directionButton.addTarget(self, action: #selector(self.didOpenDirection(_:)), for: .touchUpInside)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as! CommentsView
            
            if let getData = self.workViewModel.orderDetail?.bidder {
                cell.setupComments(getData)
            }
            
            return cell
        }
    }
    
    @objc func didZoomImage(_ sender: UITapGestureRecognizer) {
        
        if self.workViewModel.orderDetail?.type == "video" {
            let videoURL = self.workViewModel.orderDetail?.media ?? ""
            if let urlVid = URL(string: videoURL) {
                let player = AVPlayer(url: urlVid)
                let vc = AVPlayerViewController()
                vc.player = player
                
                present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        } else {
            let gallery = CollieGallery(pictures: pictures)
            gallery.presentInViewController(self)
        }
        
    }
    
}
