//
//  HistoryCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import Kingfisher

class HistoryCell: UITableViewCell {

    @IBOutlet weak var containers: BXView!
    @IBOutlet weak var imageJobs: UIImageView!
    @IBOutlet weak var categoryJob: UILabel!
    @IBOutlet weak var timeJob: UILabel!
    @IBOutlet weak var dollarsJob: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var borderStatus: BXView!
    @IBOutlet weak var btnPlay: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupHistory(_ data: Histories) {
        if let photoJobs = data.thumbnail {
            guard let urlPhotoJobs = URL(string: photoJobs) else {
                return
            }
            self.imageJobs.kf.setImage(with: urlPhotoJobs)
        }
        
        self.categoryJob.text = data.category
        self.timeJob.text = data.createdAt
        self.dollarsJob.text = data.price?.replaceCurrenyLocal
        
        if let statusOrder = data.status {
            self.status.text = StatusHelper.generateWording(statusOrder)
            self.borderStatus.borderColor = StatusHelper.generateColor(statusOrder)
            self.status.textColor = StatusHelper.generateColor(statusOrder)
        }
        
        if data.type == "image" {
            self.btnPlay.isHidden = true
        } else {
            self.btnPlay.isHidden = false
        }
        
    }

}
