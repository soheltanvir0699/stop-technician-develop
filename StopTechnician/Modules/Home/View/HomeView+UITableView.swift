//
//  HomeView+UITableView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1 //2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 2
//        } else {
            return self.homeViewModel.countJobs()
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "promotion", for: indexPath) as! PromotionCell
        
//        if indexPath.section == 0 {
//            if indexPath.row == 0 {
//                cell.setupCurrentPromotion()
//            } else if indexPath.row == 1 {
//                cell.setupUpcomingPromotion()
//            }
//            return cell
//        } else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "newjob", for: indexPath) as! JobViewCell
        
        if let getData = self.homeViewModel.getData(index: indexPath.row){
            cell.buildAvailbleWork(getData)
        }
            return cell
        //}
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! JobHeader
            return cell
//        } else {
//            return UIView()
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        } else { return 0 } //0 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
        if let getData = self.homeViewModel.getData(index: indexPath.row){
            let bidding = UIStoryboard.init(name: "BiddingView", bundle: Bundle.main).instantiateViewController(withIdentifier: "BiddingView") as! BiddingView
            bidding.id = getData.id ?? ""
            self.navigationController?.pushViewController(bidding, animated: true)
        }
        
//        }
    }
    
}
