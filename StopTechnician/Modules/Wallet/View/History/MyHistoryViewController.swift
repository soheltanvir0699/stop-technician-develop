//
//  MyHistoryViewController.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 14/11/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyHistoryViewController: StopAppBaseView, IndicatorInfoProvider {
    // MARK: - Indicator info provider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: GusSetLanguage.getLanguage(key: "menu.wallet.myhistory"))
    }
    
    
    @IBOutlet weak var tableView: SDStateTableView!
    
    var walletViewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = .white
        
        self.initViewModel()
        
        self.tableView.es.addPullToRefresh {
            self.initViewModel()
            self.tableView.es.stopPullToRefresh()
        }
        
    }
    
    fileprivate func initViewModel() {
        
        self.walletViewModel.showAlertClosure = {
            self.alertMessage("", message: self.walletViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.walletViewModel.updateLoadingStatus = {
            if self.walletViewModel.isLoading {
                
                self.tableView.reloadData()
                self.tableView.showLoader()
                
            } else {
                
                self.tableView.reloadData()
                self.tableView.hideLoader()
            }
        }
        
        self.walletViewModel.internetConnectionStatus = {
            self.setInternetErrorState(self.tableView, completion: {
                self.walletViewModel.didGetWallet(fetchMode: .fresh, completion: {})
            })
        }
        
        self.walletViewModel.serverErrorStatus = {
            self.setServerErrorState(self.tableView, completion: {
                self.walletViewModel.didGetWallet(fetchMode: .fresh, completion: {})
            })
        }
        
        self.walletViewModel.didGetWalletMonthly(fetchMode: .fresh) {
            if self.walletViewModel.countMonthly == 0 {
                self.tableView.setState(
                    .withImage(image: "noHistory",
                               title: GusSetLanguage.getLanguage(key: "wallet.empty.title.history"),
                               message: GusSetLanguage.getLanguage(key: "wallet.empty.message.history")))
            } else {
                self.tableView.setState(.dataAvailable)
                self.setupDirectionAnimation(.bottom)
                self.tableView.reloadData()
            }
        }
        
    }
    
}

extension MyHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.walletViewModel.countMonthly == 0 {
            return 0
        } else {
            if section == 0 {
                return 1
            } else {
                return self.walletViewModel.countMonthly ?? 3
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headWeekly", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryViewCell
            
            if let _ = self.walletViewModel.countMonthly {
                let data = self.walletViewModel.monthlyData(indexPath.row)
                cell.setupHistory(data)
            }
            
            return cell
        }
        
    }
    
    
}
