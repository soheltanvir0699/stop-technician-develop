//
//  HeaderViewCell.swift
//  StopApp
//
//  Created by Agus Cahyono on 30/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var locationUser: UILabel!
    @IBOutlet weak var rateUser: FloatRatingView!
    
    static func createNib() -> UINib {
        return UINib(nibName: "HeaderViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupHeader() {
        
        if let photoUser = Profile.shared?.photo {
            if let urlPhoto = URL(string: photoUser) {
                self.avatarUser.kf.setImage(with: urlPhoto)
            }
        }
        
        self.locationUser.text = Profile.shared?.address ?? "No address"
        self.nameUser.text = Profile.shared?.name ?? ""
        
        if let getRate = Profile.shared?.rate {
            self.rateUser.rating = Double(getRate)
        } else {
            self.rateUser.rating = 0
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
