//  
//  BiddingView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import CollieGallery

class BiddingView: StopAppBaseView {

    // OUTLETS HERE
    @IBOutlet weak var tableView: UITableView!

    // VARIABLES HERE
    var id: String = ""
    var pictures = [CollieGalleryPicture]()
    var bidViewModel = BiddingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(HeaderBid.build(), forCellReuseIdentifier: "header")
        
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
        self.bidViewModel.updateLoadingStatus = {
            if self.bidViewModel.isLoading {
                self.showLoading()
            } else {
                self.dismissLoading()
            }
        }
        
        //---------
        self.bidViewModel.showAlertClosure = {
            self.alertMessage("", message: self.bidViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.bidViewModel.getBidContent(self.id) {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
        self.setNavigationBar("", color: "#F5FAFE")
    }
    
    @IBAction func didSubmitBidding(_ sender: UIButton) {
        let options = [
            SemiModalOption.pushParentBack: false
        ]
        
        let biddersForm = self.storyboard?.instantiateViewController(withIdentifier: "BiddingFormView") as! BiddingFormView
        biddersForm.view.height = self.view.bounds.size.height - 18
        biddersForm.delegate = self
        
        self.presentSemiViewController(biddersForm, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
            print("Dismissed!")
        })
    }
    
    @objc func didOpenLocation(_ sender: UIButton) {
        
    }
    
}

extension BiddingView: BiddingFormDelegate {
    
    func dismissView() {
        self.dismissSemiModalView()
    }
    
    func didSubmitOrder() {
        self.dismissSemiModalView()
        self.bidViewModel.didBidSubmit(self.id) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("openmyorder"), object: nil)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }        
    }
    
}

extension BiddingView: UITableViewDelegate, UITableViewDataSource {
    
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
            
            if let getData = self.bidViewModel.orderDetail {
                cell.headerOrderDetail(getData)
                
                let picture = CollieGalleryPicture(url: getData.thumbnail ?? "")
                pictures.append(picture)
                
            }
            
            let gestureImage = UITapGestureRecognizer(target: self, action: #selector(self.didZoomImage(_:)))
            cell.imagePlaceholder.isUserInteractionEnabled = true
            cell.imagePlaceholder.addGestureRecognizer(gestureImage)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! InfoBiddingCell
            
            if let getData = self.bidViewModel.orderDetail {
                cell.setupinfoOrders(getData)
            }
            
            cell.buttonLocation.addTarget(self, action: #selector(self.didOpenLocation(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func didZoomImage(_ sender: UITapGestureRecognizer) {
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
    }
    
}
