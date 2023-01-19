//
//  NotifViewCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class NotifViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarUser: BXImageView!
    @IBOutlet weak var titleNotifications: UILabel!
    @IBOutlet weak var messageNotifications: UILabel!
    @IBOutlet weak var timeNotifications: UILabel!
    @IBOutlet weak var isRead: BXView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupNotifications(_ data: Notif) {
        
        if let imageURL = data.icon {
            if let iconNotif = URL(string: imageURL) {
                self.avatarUser.kf.setImage(with: iconNotif)
            }
        }
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold(data.name ?? "", fontSize: 14.0)
            .normal(" ", fontSize: 14.0)
            .normal(data.title ?? "", fontSize: 14.0)
        self.titleNotifications.attributedText = formattedString
        
        self.messageNotifications.text = data.description ?? ""
        
        let time = GusDateHelper.converttoDateFormat(original: data.createdAt ?? "")
        self.timeNotifications.text = time.timeAgoSinceDate(numericDates: true)
        
        if let readed = data.read {
            if readed {
                self.isRead.isHidden = true
            } else {
                self.isRead.isHidden = false
            }
        } else {
            self.isRead.isHidden = true
        }
    }

}
