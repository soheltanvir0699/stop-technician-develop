//
//  PromotionCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class PromotionCell: UITableViewCell {
    
    @IBOutlet weak var wordingCurrentPromotion: UILabel!
    @IBOutlet weak var wordingFeePromotion: UILabel!
    @IBOutlet weak var timePromotion: UILabel!
    @IBOutlet weak var iconPromotion: UIImageView!
    @IBOutlet weak var container: BXView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCurrentPromotion() {
        self.wordingCurrentPromotion.text = "Current Promotion"
        self.wordingFeePromotion.text = "Get $30 Today"
        self.timePromotion.text = "Now - Fri, 4 AM"
        self.iconPromotion.image = #imageLiteral(resourceName: "currentpromotionicon")
        self.container.dropShadow()
    }
    
    func setupUpcomingPromotion() {
        self.wordingCurrentPromotion.text = "Upcoming Promotion"
        self.wordingFeePromotion.text = "Get Extra $30"
        self.timePromotion.text = "Now - Sat, 4 AM"
        self.iconPromotion.image = #imageLiteral(resourceName: "upcomingpromotionlogo")
        self.container.dropShadow()
    }

}
