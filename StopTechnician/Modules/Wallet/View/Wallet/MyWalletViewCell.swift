//
//  MyWalletViewCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import Kingfisher

class MyWalletViewCell: UITableViewCell {
    
    
    @IBOutlet weak var subCategoryName: UILabel!
    @IBOutlet weak var iconWallet: UIImageView!
    @IBOutlet weak var dateWallet: UILabel!
    @IBOutlet weak var priceWallet: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var amountWeek: UILabel!
    @IBOutlet weak var thisWeekWording: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWallet(_ data: WalletActivity) {
        self.subCategoryName.text = data.subCategory
        if let theIconWallet = data.icon {
            guard let urlIconWallet = URL(string: theIconWallet) else {
                return
            }
            self.iconWallet.kf.setImage(with: urlIconWallet)
        }
        
        self.priceWallet.text = data.price?.replaceCurrenyLocal
        self.paymentMethod.text = data.paymentMethod?.capitalized
        
    }
    
}
