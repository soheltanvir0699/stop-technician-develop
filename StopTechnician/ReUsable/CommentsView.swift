//
//  CommentsView.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class CommentsView: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarUser: BXImageView!
    @IBOutlet weak var bidderMessage: UILabel!
    @IBOutlet weak var bidderFullname: UILabel!
    @IBOutlet weak var bidderRate: FloatRatingView!
    @IBOutlet weak var wordingTimeStart: UILabel!
    @IBOutlet weak var bidderStartTime: UILabel!
    
    
    
    static func build() -> UINib {
        return UINib(nibName: "CommentsView", bundle: Bundle.main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupComments(_ data: Bidder) {
        
        if let imageURL = data.photo {
            if let photoUser = URL(string: imageURL) {
                self.avatarUser.kf.setImage(with: photoUser)
            }
        }
        
        self.bidderFullname.text = data.engineerName ?? ""
        self.bidderMessage.text = data.message ?? ""
        self.bidderRate.rating = data.rate ?? 0
        
        if let timeStartJob = data.startingTime {
            let refactorDate = GusDateHelper.convertDateFormat(original: timeStartJob)
            let convertDate = GusDateHelper.convertDateStringToString(date: refactorDate, format: .timeAndDashed)
            self.bidderStartTime.text = convertDate
        }
        
    }
    
}
