//
//  SettingViewCell.swift
//  StopTechician
//
//  Created by Agus Cahyono on 21/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: BXImageView!
    @IBOutlet weak var buttonChangePhoto: UIButton! {
        didSet {
            buttonChangePhoto.setTitle(GusSetLanguage.getLanguage(key: "setting.menu.changePhoto"), for: .normal)
        }
    }
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var buttonChangePhone: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var specialized: UILabel!
    @IBOutlet weak var experienced: UILabel!
    @IBOutlet weak var invitationCode: UILabel!
    
    @IBOutlet weak var buttonBankAccount: UIButton!
    @IBOutlet weak var currentLanguage: UILabel! {
        didSet {
            let lang = Profile.shared?.lang ?? ""
            if lang == "en" {
                self.currentLanguage.text = "English"
            } else {
                self.currentLanguage.text = "العربية"
            }
        }
    }
    @IBOutlet weak var buttonChangeLang: UIButton!
    @IBOutlet weak var buttonRateApp: UIButton!
    
    @IBOutlet weak var profileSectionTitle: UILabel! {
        didSet {
            if GusLanguage.shared.currentLang == "en" {
                self.profileSectionTitle.text = "Profile"
            } else {
                self.profileSectionTitle.text = "الملف الشخصي"
            }
        }
    }
    @IBOutlet weak var payoutSectionTitle: UILabel! {
        didSet {
            if GusLanguage.shared.currentLang == "en" {
                self.payoutSectionTitle.text = "Payout"
            } else {
                self.payoutSectionTitle.text = "دفع تعويضات"
            }
        }
    }
    @IBOutlet weak var generalSectionTitle: UILabel! {
        didSet {
            if GusLanguage.shared.currentLang == "en" {
                self.generalSectionTitle.text = "General"
            } else {
                self.generalSectionTitle.text = "عام"
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupAvatar() {
        if let photoURL = Profile.shared?.photo {
            guard let urlAvatar = URL(string: photoURL) else {
                return
            }
            self.avatarImage.kf.setImage(with: urlAvatar)
        }
    }
    
    func setupProfile() {
        self.fullname.text      = Profile.shared?.name
        self.phoneNumber.text   = Profile.shared?.phone
        self.emailaddress.text  = Profile.shared?.email
        self.address.text       = Profile.shared?.address
        self.specialized.text   = Profile.shared?.specialized
        
        if let theExperience = Profile.shared?.experience {
             self.experienced.text   = "\(theExperience) years"
        }
        
        self.invitationCode.text = Profile.shared?.referralCode
       
    }

}
