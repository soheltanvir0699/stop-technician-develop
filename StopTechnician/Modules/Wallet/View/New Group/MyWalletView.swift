//
//  MyWalletView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyWalletView: StopAppBaseView, IndicatorInfoProvider {
    // MARK: - Indicator info provider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: GusSetLanguage.getLanguage(key: "menu.wallet.mywallet"))
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
        
        self.walletViewModel.didGetWallet(fetchMode: .fresh) {
            if self.walletViewModel.countSection == 0 {
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

extension MyWalletView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.walletViewModel.countSection == 0 {
            return 0
        } else {
            return self.walletViewModel.countSection + 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.walletViewModel.countSection == 0 {
            return 0
        } else {
            if section == 0 {
                return 1
            } else {
                return self.walletViewModel.count(section: section - 1) ?? 3
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! MyWalletViewCell
            
            cell.amountWeek.text = self.walletViewModel.getAmountWeekly?.replaceCurrenyLocal
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "daily", for: indexPath) as! MyWalletViewCell
            
            if let _ = self.walletViewModel.count(section: indexPath.section - 1) {
                
                let data = self.walletViewModel.getData(At: indexPath.section - 1, index: indexPath.row)
                if let theData = data {
                    cell.setupWallet(theData)
                }
                
                let dateData = self.walletViewModel.getData(At: indexPath.section - 1)
                cell.dateWallet.text = dateData.date
                
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section != 0 {
            let headerView = UIView()
            let cell = tableView.dequeueReusableCell(withIdentifier: "headWeekly")

            let headLabel = cell?.viewWithTag(1) as! UILabel
            let data = self.walletViewModel.getData(At: section - 1)
            headLabel.text = data.date

            headerView.addSubview(cell!)
            return headerView
        } else {
            return nil
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }

}

