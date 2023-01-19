//  
//  HistoryView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class HistoryView: StopAppBaseView {

    // OUTLETS HERE
    @IBOutlet weak var tableView: SDStateTableView!
    
    // VARIABLES HERE
    var historyViewModel = HistoryViewModel()
    var id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.backgroundColor = UIColor.hexStringToUIColor(hex: "F5FAFE")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        self.initViewModel()
        self.tableView.es.addPullToRefresh {
            self.initViewModel()
            self.tableView.es.stopPullToRefresh()
        }
        
    }
    
    fileprivate func initViewModel() {
        
        self.historyViewModel.showAlertClosure = {
            self.alertMessage("", message: self.historyViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
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
                self.historyViewModel.getHostiries(fetchMode: .fresh, completion: {})
            })
        }
        
        self.historyViewModel.serverErrorStatus = {
            self.setServerErrorState(self.tableView, completion: {
                self.historyViewModel.getHostiries(fetchMode: .fresh) {}
            })
        }
        
        self.historyViewModel.getHostiries(fetchMode: .fresh) {
            if self.historyViewModel.count == 0 {
                self.tableView.setState(
                    .withImage(image: "noHistory",
                               title: GusSetLanguage.getLanguage(key: "wallet.empty.title.history"),
                               message: GusSetLanguage.getLanguage(key: "wallet.empty.message.history")))
            } else {
                self.tableView.setState(.dataAvailable)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar(GusSetLanguage.getLanguage(key: "menu.history.replace"), color: "E42F38", titleColor: "FFFFFF")
        self.navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
    }
    
    @IBAction func didDismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HistoryView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyViewModel.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryCell
        
        if let _ = self.historyViewModel.count {
            let data = self.historyViewModel.dataOn(index: indexPath.row)
            cell.setupHistory(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.historyViewModel.dataOn(index: indexPath.row)
        
        self.id = data.id ?? ""
        self.performSegue(withIdentifier: "historydetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historydetail" {
            let destination = segue.destination as! HistoryDetailViewController
            destination.id = self.id
        }
    }
    
}

