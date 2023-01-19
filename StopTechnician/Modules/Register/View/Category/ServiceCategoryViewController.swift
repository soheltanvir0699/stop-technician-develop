//
//  ServiceCategoryViewController.swift
//  StopApp
//
//  Created by Agus Cahyono on 28/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func didSelectedCategory(id: Int,_ name: String)
}

class ServiceCategoryViewController: StopAppBaseView, SBCardPopupContent {
    
    
    var popupViewController: SBCardPopupViewController?
    var allowsTapToDismissPopupCard: Bool = true
    var allowsSwipeToDismissPopupCard: Bool = true
    
    var selectedCategory: (() -> ())?
    
    static func build(_ completion: @escaping() -> ()) -> ServiceCategoryViewController {
        
        let category = UIStoryboard.init(name: "RegisterView", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceCategoryViewController") as! ServiceCategoryViewController
        
        category.selectedCategory = {
            completion()
        }
        
        return category
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var allowDidSelected = false
    var delegate: CategoryDelegate?
    var specialViewModel = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setArrowBack(imageArrow: #imageLiteral(resourceName: "right-arrow"))
    }
    
    fileprivate func bindViewModel() {
        
        self.specialViewModel.updateLoadingStatus = {
            if self.specialViewModel.isLoading {
                self.delayWithSeconds(0, completion: {
                    AMShimmer.start(for: self.tableView)
                })
            } else {
                self.delayWithSeconds(0, completion: {
                    AMShimmer.stop(for: self.view)
                })
            }
        }
        
        self.specialViewModel.showAlertClosure = {
            let alertMessage = self.specialViewModel.alertMessage ?? ""
            self.alertMessage("", message: alertMessage)
        }
        
        self.specialViewModel.didGetCategory()
        self.specialViewModel.finishGetCategory = {
            self.tableView.reloadData()
        }
        
    }
    
    
}


extension ServiceCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.specialViewModel.countSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        if let data = self.specialViewModel.buildSection(index: indexPath.row) {
            cell.bindSection(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let data = self.specialViewModel.buildSection(index: indexPath.row) {
            
            self.delegate?.didSelectedCategory(id: data.id ?? 0, data.name ?? "")
            self.selectedCategory?()
            self.popupViewController?.close()
            
        }
        
    }
}
