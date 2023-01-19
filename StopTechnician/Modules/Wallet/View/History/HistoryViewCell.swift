//
//  HistoryViewCell.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 14/11/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var dateHistory: UILabel!
    @IBOutlet weak var priceWallet: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupHistory(_ data: WalletMonthly) {
        self.dateHistory.text = data.month
        self.priceWallet.text = data.nominal?.replaceCurrenyLocal
    }

}
