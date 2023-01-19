//
//  HeaderBid.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class HeaderBid: UITableViewCell {
    
    @IBOutlet weak var imagePlaceholder: BXImageView!
    @IBOutlet weak var avatarUser: BXImageView!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientAddress: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratedView: FloatRatingView!
    @IBOutlet weak var buttonPlay: UIButton!
    
    
    static func build() -> UINib {
        return UINib(nibName: "HeaderBid", bundle: Bundle.main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func headerOrderDetail(_ data: Orders) {
        if let imageURL = data.thumbnail {
            if let mediaThumbnail = URL(string: imageURL) {
                self.imagePlaceholder.kf.setImage(with: mediaThumbnail)
            }
        }
        
        if let imageClient = data.customer?.photo {
            if let userPhoto = URL(string: imageClient) {
                self.avatarUser.kf.setImage(with: userPhoto)
            }
        }
        
        self.clientName.text = data.customer?.fullname ?? ""
        self.clientAddress.text = data.customer?.address ?? ""
        self.priceLabel.text = data.price?.replaceCurrenyLocal
        self.ratedView.rating = data.customer?.rate ?? 0
        
        if data.type == "video" {
            self.buttonPlay.isHidden = false
        } else {
            self.buttonPlay.isHidden = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
