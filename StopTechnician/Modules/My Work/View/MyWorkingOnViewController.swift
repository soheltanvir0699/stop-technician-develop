//
//  MyWorkingOnViewController.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyWorkingOnViewController: StopAppBaseView, IndicatorInfoProvider {
    
    // MARK: - Indicator info provider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: GusSetLanguage.getLanguage(key: "menu.work.mywork"))
    }

    @IBOutlet weak var tableview: SDStateTableView!
    var workViewModel = MyWorkViewModel()
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.backgroundColor = .white
        self.tableview.estimatedRowHeight = 60
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.register(JobViewCell.build(), forCellReuseIdentifier: "newjob")
        
        self.bindViewModel()
        
        
        self.tableview.es.addPullToRefresh {
            self.bindViewModel()
            self.tableview.es.stopPullToRefresh()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func bindViewModel() {
        
        self.workViewModel.updateLoadingStatus = {
            if self.workViewModel.isLoading {
                
                self.tableview.reloadData()
                self.tableview.showLoader()
                
            } else {
                
                self.tableview.reloadData()
                self.tableview.hideLoader()
                
            }
        }
        
        //---------
        self.workViewModel.showAlertClosure = {
            self.alertMessage("", message: self.workViewModel.alertMessage ?? "", completion: {
                
            })
        }
        
        self.workViewModel.didGetWork {
            if self.workViewModel.count == 0 {
                self.tableview.setState(
                    .withImage(image: "noJobs",
                               title: GusSetLanguage.getLanguage(key: "work.empty.title"),
                               message: GusSetLanguage.getLanguage(key: "work.empty.message") ))
            } else {
                self.tableview.setState(.dataAvailable)
            }
            
             self.tableview.reloadData()
        }
        
    }
    
    
}

extension MyWorkingOnViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workViewModel.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "newjob", for: indexPath) as! JobViewCell
        
        if let _ = self.workViewModel.count {
            let data = self.workViewModel.selectedObject(index: indexPath.row)
            
            if let getData = data {
                cell.buildCell(getData)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let data = self.workViewModel.selectedObject(index: indexPath.row)
        self.id = data?.id ?? ""
        
        self.performSegue(withIdentifier: "detailworking", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailworking" {
            let destination = segue.destination as! DetailWorkingViewController
            destination.id = self.id
        }
    }
    
}
