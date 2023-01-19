//
//  MenuCell.swift
//  StopApp
//
//  Created by Agus Cahyono on 30/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    static func createNib() -> UINib {
        return UINib(nibName: "MenuCell", bundle: nil)
    }
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuBadge: BadgeSwift!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
