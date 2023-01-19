//
//  RateReviewCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class RateReviewCell: UITableViewCell {
    
    @IBOutlet weak var titleRateReviewWording: UILabel!
    @IBOutlet weak var clientRate: FloatRatingView!
    @IBOutlet weak var clientMessage: UILabel!
    @IBOutlet weak var clientAvatar: BXImageView!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientAddress: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCustomer(_ data: Customer) {
        self.clientRate.rating = data.rate ?? 0
        if let photoUser = data.photo {
            guard let userPhoto = URL(string: photoUser) else {
                return
            }
            self.clientAvatar.kf.setImage(with: userPhoto)
        }
        self.clientName.text = data.fullname ?? ""
        self.clientAddress.text = data.address ?? ""
        self.clientMessage.text = "-"
    }

}
