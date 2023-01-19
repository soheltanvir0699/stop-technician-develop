//
//  BiddingFormView.swift
//  StopTechician
//
//  Created by Agus Cahyono on 20/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

protocol BiddingFormDelegate {
    func dismissView()
    func didSubmitOrder()
}

class BiddingFormView: StopAppBaseView, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var categoryBid: UILabel!
    @IBOutlet weak var descriptionBid: KMPlaceholderTextView!
    @IBOutlet weak var priceBid: UITextField! {
        didSet {
            priceBid.keyboardType = .decimalPad
        }
    }
    @IBOutlet weak var dateStartBid: BXButton! {
        didSet {
            dateStartBid.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: "#273D52")
            dateStartBid.addTarget(self, action: #selector(self.didOpenDatePicker(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var timeStartBid: BXButton! {
        didSet {
            timeStartBid.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: "#273D52")
            timeStartBid.addTarget(self, action: #selector(self.didOpenTimePicker(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var buttonBidNow: UIButton! {
        didSet {
            self.buttonBidNow.addTarget(self, action: #selector(self.didSubmitOrder(_:)), for: .touchUpInside)
        }
    }
    
    lazy var timepicker: WWCalendarTimeSelector = {
        
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        selector.optionTintColor = UIColor.hexStringToUIColor(hex: "#E42F38")
        return selector
        
    }()
    
    lazy var datepicker: WWCalendarTimeSelector = {
        
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(true)
        selector.optionStyles.showTime(false)
        selector.optionTintColor = UIColor.hexStringToUIColor(hex: "#E42F38")
        return selector
        
    }()
    
    fileprivate var singleDate: Date = Date()
    var isDatePickerSelect = true
    var delegate: BiddingFormDelegate?
    var dateSelected = ""
    var hourSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.roundCorners([.topLeft, .topRight], radius: 15)
    }
    
    @objc func didOpenDatePicker(_ sender: UIButton) {
        self.isDatePickerSelect = true
        present(datepicker, animated: true, completion: nil)
    }
    
    @objc func didOpenTimePicker(_ sender: UIButton) {
        self.isDatePickerSelect = false
        present(timepicker, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if self.isDatePickerSelect {
            let datePicker = date.stringFromFormat("yyyy'-'MM'-'dd'")
            self.dateSelected = datePicker
            self.dateStartBid.setTitle(datePicker, for: .normal)
        } else {
            let timePicker = date.stringFromFormat("HH':'mm'")
            
            let getTime = date.stringFromFormat("HH':'mm':'ss'")
            self.hourSelected = getTime
            self.timeStartBid.setTitle(timePicker, for: .normal)
        }
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
    }
    
    @IBAction func dismissView(_ sender: DismissButton) {
        self.delegate?.dismissView()
    }
    
    @objc func didSubmitOrder(_ sender: UIButton) {
        
        let message = self.descriptionBid.text ?? ""
        let price = self.priceBid.text ?? ""

        if message.isEmpty {
            self.alertMessage("", message: GusSetLanguage.getLanguage(key: "global.alert.bidding.message"))
        } else if price.isEmpty {
            self.alertMessage("", message: GusSetLanguage.getLanguage(key: "global.alert.bidding.price"))
        } else if dateSelected.isEmpty {
            self.alertMessage("", message: GusSetLanguage.getLanguage(key: "global.alert.bidding.datestart"))
        } else if hourSelected.isEmpty {
            self.alertMessage("", message: GusSetLanguage.getLanguage(key: "global.alert.bidding.hourstart"))
        } else {
        
            Bidding.shared.messageBid = message
            Bidding.shared.priceBid = Double(price) ?? 0
            Bidding.shared.startingTimeBid = self.dateSelected + " " + self.hourSelected
            
            self.delegate?.didSubmitOrder()
        }
    
    }

}
