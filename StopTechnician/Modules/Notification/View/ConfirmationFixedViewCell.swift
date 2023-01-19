//
//  ConfirmationFixedViewCell.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class ConfirmationFixedViewCell: UITableViewCell {
    
    @IBOutlet weak var btnAccept: UIButton! {
        didSet {
            btnAccept.layer.cornerRadius = 3
            btnAccept.clipsToBounds = true
            btnAccept.addShadowBottom(UIColor.hexStringToUIColor(hex: "#E42F38"))
        }
    }
    @IBOutlet weak var btnReject: UIButton! {
        didSet {
            btnReject.layer.cornerRadius = 3
            btnReject.clipsToBounds = true
            btnReject.addShadowBottom(UIColor.hexStringToUIColor(hex: "#273D52"))
        }
    }
    
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var clientMessage: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
