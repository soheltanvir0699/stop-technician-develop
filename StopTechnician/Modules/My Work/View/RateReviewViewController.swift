//
//  RateReviewViewController.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class RateReviewViewController: StopAppBaseView {

    @IBOutlet weak var rateContent: FloatRatingView! {
        didSet {
            self.rateContent.type = .wholeRatings
            self.rateContent.delegate = self
            self.rateContent.contentMode = UIView.ContentMode.scaleAspectFit
        }
    }
    @IBOutlet weak var reviewContent: KMPlaceholderTextView! {
        didSet {
            reviewContent.layer.borderWidth = 1.0
            reviewContent.layer.borderColor = UIColor.hexStringToUIColor(hex: "#E0EAF3").cgColor
            reviewContent.layer.cornerRadius = 3
            reviewContent.clipsToBounds = true
        }
    }
    
    var workViewModel = MyWorkViewModel()
    var id: String = ""
    
    var getRate: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
//        self.delayWithSeconds(2) {
//            let popup = CashBackDialogView.build("CONGRATULATIONS", message: " 'Ayman gives you excellent X amount will be rewarded at your wallet' ")
//            let dialog = SBCardPopupViewController(contentViewController: popup)
//            dialog.show(onViewController: self)
//        }
    }
    
    func bindViewModel() {
        
        self.workViewModel.updateLoadingStatus = {
            if self.workViewModel.isLoading {
                self.showLoading()
            } else {
                self.dismissLoading()
            }
        }
        
        
        //---------
        self.workViewModel.showAlertClosure = {
            self.alertMessage("", message: self.workViewModel.alertMessage ?? "", completion: {
                let viewController = UIStoryboard.init(name: "HistoryView", bundle: Bundle.main).instantiateViewController(withIdentifier: "HistoryView") as! HistoryView
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didRateReview(_ sender: UIButton) {
        let message = self.reviewContent.text ?? ""
        
        if message.isEmpty {
            self.alertMessage("", message: GusSetLanguage.getLanguage(key: "global.alert.rate.empty.review")) {
                self.reviewContent.becomeFirstResponder()
            }
        } else if self.getRate == 0 {
            self.alertMessage("", message: GusSetLanguage.getLanguage(key: "global.alert.rate.empty.review.client")) {
                
            }
        } else {
            self.workViewModel.rateTheOrder(self.id, rate: self.getRate, message: message) { success in
                
                self.alertMessage("", message: success, completion: {
                    let viewController = UIStoryboard.init(name: "HistoryView", bundle: Bundle.main).instantiateViewController(withIdentifier: "HistoryView") as! HistoryView
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
                
            }
        }
        
//        self.showLoading()
//        delayWithSeconds(2) {
//            self.dismissLoading()
//            self.dismiss(animated: true, completion: nil)
//        }
    }

}

extension RateReviewViewController: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        _ = self.rateContent.rating
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let star = self.rateContent.rating
        self.getRate = star
    }
    
}
