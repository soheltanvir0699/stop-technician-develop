//
//  CategoryTableViewCell.swift
//  StopApp
//
//  Created by Agus Cahyono on 03/07/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var IconCategoryName: UIImageView! {
        didSet {
            self.IconCategoryName.image = self.IconCategoryName.image?.withRenderingMode(.alwaysTemplate)
            self.IconCategoryName.layer.cornerRadius = self.IconCategoryName.size.width / 2
            self.IconCategoryName.clipsToBounds = true
        }
    }
    @IBOutlet weak var CataegoryName: UILabel! {
        didSet {
            self.CataegoryName.font = UIFont.init(name: "CircularStd-Bold", size: 14)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindSection(_ data: Specialize) {
        self.CataegoryName.text = data.name
        if let urlIcon = data.icon {
            let url = URL(string: urlIcon)
            self.IconCategoryName.kf.setImage(with: url!, placeholder: #imageLiteral(resourceName: "wrench"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
}
