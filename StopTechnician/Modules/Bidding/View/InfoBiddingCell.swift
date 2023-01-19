//
//  InfoBiddingCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class InfoBiddingCell: UITableViewCell {
    
    @IBOutlet weak var categoryBids: UILabel!
    @IBOutlet weak var buttonLocation: BXButton!
    @IBOutlet weak var descriptionBids: UILabel!
    @IBOutlet weak var countDownTimeBids: CountdownLabel!
    @IBOutlet weak var statusMessageBids: UILabel!
    @IBOutlet weak var wordingTotalBids: UILabel!
    @IBOutlet weak var totalBids: UILabel!
    @IBOutlet weak var statusBidsWording: UILabel!
    @IBOutlet weak var statusBids: BXButton!
    
    @IBOutlet weak var directionWording: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var buttonCall: BXButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupinfoOrders(_ data: Orders) {
        self.categoryBids.text = data.category
        self.descriptionBids.text = data.description
        self.totalBids.text = "\(data.totalBid ?? 0) Bids"
        
        if let getStatus = data.status {
            self.statusBids.setTitle(StatusHelper.generateWording(getStatus), for: .normal)
            self.statusBids.borderColor = StatusHelper.generateColor(getStatus)
            self.statusBids.setTitleColor(StatusHelper.generateColor(getStatus), for: .normal)
        }
        
        let endTime = GusDateHelper.toDateFormat(original: data.expiredTime ?? "")
        let dateRemaining = GusDateHelper.calculateDaysBetweenTwoDates(start: Date(), end: endTime)
        
        let countMinutes: TimeInterval = TimeInterval(abs(dateRemaining) * 60)
        self.countDownTimeBids.setCountDownTime(minutes: countMinutes)
        self.countDownTimeBids.start()
            
    }
    
    func setupInfoOrderWorking(_ data: Orders) {
        self.categoryBids.text = data.category
        self.descriptionBids.text = data.description
        self.totalBids.text = "\(data.totalBid ?? 0) Bids"
        
        if let getStatus = data.status {
            self.statusBids.setTitle(StatusHelper.generateWording(getStatus), for: .normal)
            self.statusBids.borderColor = StatusHelper.generateColor(getStatus)
            self.statusBids.setTitleColor(StatusHelper.generateColor(getStatus), for: .normal)
        }
    }

}
