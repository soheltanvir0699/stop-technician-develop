//
//  JobViewCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 07/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class JobViewCell: UITableViewCell {
    
    
    @IBOutlet weak var container: BXView!
    @IBOutlet weak var imagejob: UIImageView!
    @IBOutlet weak var categoryjob: UILabel!
    @IBOutlet weak var timejob: UILabel!
    @IBOutlet weak var countdownjob: CountdownLabel!
    @IBOutlet weak var statusjob: UILabel!
    @IBOutlet weak var statusContainer: BXView!
    @IBOutlet weak var pricejob: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    static func build() -> UINib {
        return UINib(nibName: "JobViewCell", bundle: Bundle.main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func buildCell(_ data: Working) {
        self.container.dropShadow()
        self.imagejob.roundCorners([.topLeft, .bottomLeft], radius: 3)
        
        if let imageURL = data.thumbnail {
            if let thumbnails = URL(string: imageURL) {
                self.imagejob.kf.setImage(with: thumbnails)
            }
        }
        
        self.categoryjob.text = data.category
        self.timejob.text = data.createdAt
        self.pricejob.text = data.price?.replaceCurrenyLocal
        
        if let statusOrder = data.status {
            self.statusjob.text = StatusHelper.generateWording(statusOrder)
            self.statusContainer.borderColor = StatusHelper.generateColor(statusOrder)
            self.statusjob.textColor = StatusHelper.generateColor(statusOrder)
        }
        
        if data.type == "image" {
            self.btnPlay.isHidden = true
        } else {
            self.btnPlay.isHidden = false
        }
        
        let endTime = GusDateHelper.toDateFormat(original: data.expired_time ?? "")
        let dateRemaining = GusDateHelper.calculateDaysBetweenTwoDates(start: Date(), end: endTime)
        
        let countMinutes: TimeInterval = TimeInterval(abs(dateRemaining) * 60)
        self.countdownjob.setCountDownTime(minutes: countMinutes)
        self.countdownjob.start()
        
        
    }
    
    func buildAvailbleWork(_ data: AvailableOrder) {
        self.container.dropShadow()
        self.imagejob.roundCorners([.topLeft, .bottomLeft], radius: 3)
        
        if let imageURL = data.thumbnail {
            if let thumbnails = URL(string: imageURL) {
                self.imagejob.kf.setImage(with: thumbnails)
            }
        }
        
        self.categoryjob.text = data.category
        self.timejob.text = data.createdAt
        if let statusOrder = data.status {
            self.statusjob.text = StatusHelper.generateWording(statusOrder)
            self.statusContainer.borderColor = StatusHelper.generateColor(statusOrder)
            self.statusjob.textColor = StatusHelper.generateColor(statusOrder)
        }
        self.pricejob.text = data.price?.replaceCurrenyLocal
        
        let endTime = GusDateHelper.toDateFormat(original: data.expired_time ?? "")
        let dateRemaining = GusDateHelper.calculateDaysBetweenTwoDates(start: Date(), end: endTime)
        
        let countMinutes: TimeInterval = TimeInterval(abs(dateRemaining) * 60)
        self.countdownjob.setCountDownTime(minutes: countMinutes)
        self.countdownjob.start()
        
        if data.type == "image" {
            self.btnPlay.isHidden = true
        } else {
            self.btnPlay.isHidden = false
        }
        
        
    }
    
}
