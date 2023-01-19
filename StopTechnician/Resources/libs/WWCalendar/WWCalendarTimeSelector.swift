//
//  WWCalendarTimeSelector.swift
//  WWCalendarTimeSelector
//
//  Created by Weilson Wonder on 18/4/16.
//  Copyright © 2016 Wonder. All rights reserved.
//

import UIKit

/// Set `optionMultipleSelectionGrouping` with one of the following:
///
/// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
///
/// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
///
/// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
@objc public enum WWCalendarTimeSelectorMultipleSelectionGrouping: Int {
    /// Displayed as individual circular selection
    case simple
    /// Rounded rectangular grouping
    case pill
    /// Individual circular selection with a bar between adjacent dates
    case linkedBalls
}

/// Set `optionMultipleDateOutputFormat` with one of the following:
///
/// `English`: Displayed as "EEE', 'd' 'MMM' 'yyyy": for example, Tue, 17 Jul 2018
///
/// `Japanese`: "yyyy'年 'MMM' 'd'日 'EEE": for example, 2018年 7月 15日 日
@objc public enum WWCalendarTimeSelectorMultipleDateOutputFormat: Int {
    /// English format
    case english
    /// Japanese format
    case japanese
}

/// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
///
/// - Note:
/// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
/// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
///
/// - Note:
/// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
@objc public enum WWCalendarTimeSelectorTimeStep: Int {
    /// 1 Minute interval, but clock will display intervals of 5 minutes.
    case oneMinute = 1
    /// 5 Minutes interval.
    case fiveMinutes = 5
    /// 10 Minutes interval.
    case tenMinutes = 10
    /// 15 Minutes interval.
    case fifteenMinutes = 15
    /// 30 Minutes interval.
    case thirtyMinutes = 30
    /// Disables the selection of minutes.
    case sixtyMinutes = 60
}

@objc open class WWCalendarTimeSelectorEnabledDateRange: NSObject {
    
    public static let past: WWCalendarTimeSelectorEnabledDateRange = {
        let dateRange = WWCalendarTimeSelectorEnabledDateRange()
        dateRange.end = Date().endOfDay
        return dateRange
    }()
    
    public static let future: WWCalendarTimeSelectorEnabledDateRange = {
        let dateRange = WWCalendarTimeSelectorEnabledDateRange()
        dateRange.start = Date().beginningOfDay
        return dateRange
    }()
    
    fileprivate(set) open var start: Date? = nil
    fileprivate(set) open var end: Date? = nil
    
    open func setStartDate(_ date: Date?) {
        start = date
        if let endTmp = end, start?.compare(endTmp) == .orderedDescending {
            end = start
        }
    }
    
    open func setEndDate(_ date: Date?) {
        end = date
        if let endTmp = end, start?.compare(endTmp) == .orderedDescending {
            start = end
        }
    }
}

@objc open class WWCalendarTimeSelectorDateRange: NSObject {
    fileprivate(set) open var start: Date = Date().beginningOfDay
    fileprivate(set) open var end: Date = Date().beginningOfDay
    open var array: [Date] {
        var dates: [Date] = []
        var i = start.beginningOfDay
        let j = end.beginningOfDay
        while i.compare(j) != .orderedDescending {
            dates.append(i)
            i = i + 1.day
        }
        return dates
    }
    
    open func setStartDate(_ date: Date) {
        start = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            end = start
        }
    }
    
    open func setEndDate(_ date: Date) {
        end = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            start = end
        }
    }
}

/// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
///
/// `WWCalendarTimeSelectorDone:selector:dates:`
/// `WWCalendarTimeSelectorDone:selector:date:`
/// `WWCalendarTimeSelectorCancel:selector:dates:`
/// `WWCalendarTimeSelectorCancel:selector:date:`
/// `WWCalendarTimeSelectorWillDismiss:selector:`
/// `WWCalendarTimeSelectorDidDismiss:selector:`
@objc public protocol WWCalendarTimeSelectorProtocol {
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - date: Selected date.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - date: Selected date.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    @objc optional func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    @objc optional func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    @objc optional func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool
}

open class WWCalendarTimeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarRowProtocol, WWClockProtocol {
    
    /// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    /// `WWCalendarTimeSelectorDone:selector:date:`
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    open weak var delegate: WWCalendarTimeSelectorProtocol?
    
    /// A convenient identifier object. Not used by `WWCalendarTimeSelector`.
    open var optionIdentifier: AnyObject?
    
    /// Set `optionPickerStyle` with one or more of the following:
    ///
    /// `DateMonth`: This shows the the date and month.
    ///
    /// `Year`: This shows the year.
    ///
    /// `Time`: This shows the clock, users will be able to select hour and minutes as well as am or pm.
    ///
    /// - Note:
    /// `optionPickerStyle` should contain at least 1 of the following style. It will default to all styles should there be none in the option specified.
    ///
    /// - Note:
    /// Defaults to all styles.
    open var optionStyles: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle()
    
    /// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
    /// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
    ///
    /// - Note:
    /// Defaults to `OneMinute`.
    open var optionTimeStep: WWCalendarTimeSelectorTimeStep = .oneMinute
    
    /// Set to `true` will show the entire selector at the top. If you only wish to hide the *title bar*, see `optionShowTopPanel`. Set to `false` will hide the entire top container.
    ///
    /// - Note:
    /// Defaults to `true`.
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`.
    open var optionShowTopContainer: Bool = true
    
    /// Set to `true` to show the weekday name *or* `optionTopPanelTitle` if specified at the top of the selector. Set to `false` will hide the entire panel.
    ///
    /// - Note:
    /// Defaults to `true`.
    open var optionShowTopPanel = true
    
    /// Set to nil to show default title. Depending on `privateOptionStyles`, default titles are either **Select Multiple Dates**, **(Capitalized Weekday Full Name)** or **(Capitalized Month Full Name)**.
    ///
    /// - Note:
    /// Defaults to `nil`.
    open var optionTopPanelTitle: String? = nil
    
    /// Set `optionSelectionType` with one of the following:
    ///
    /// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
    ///
    /// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// - Note:
    /// Selection styles will only affect date selection. It is currently not possible to select multiple/range
    open var optionSelectionType: WWCalendarTimeSelectorSelection = .single
    
    /// Set to default date when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDates`
    ///
    /// - Note:
    /// Defaults to current date and time, with time rounded off to the nearest hour.
    open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDates: Set<Date> = []
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDateRange: WWCalendarTimeSelectorDateRange = WWCalendarTimeSelectorDateRange()
    
    open var optionRangeOfEnabledDates: WWCalendarTimeSelectorEnabledDateRange = WWCalendarTimeSelectorEnabledDateRange()
    
    /// Set the background blur effect, where background is a `UIVisualEffectView`. Available options are as `UIBlurEffectStyle`:
    ///
    /// `Dark`
    ///
    /// `Light`
    ///
    /// `ExtraLight`
    open var optionStyleBlurEffect: UIBlurEffect.Style = .dark
    
    /// Set `optionMultipleSelectionGrouping` with one of the following:
    ///
    /// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
    ///
    /// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
    ///
    /// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
    open var optionMultipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .pill
    
    /// Set `optionMultipleDateOutputFormat` with one of the following:
    ///
    /// `English`: Displayed as "EEE', 'd' 'MMM' 'yyyy": for example, Tue, 17 Jul 2018
    ///
    /// `Japanese`: "yyyy', 'MMM' 'd' 'EEE": for example, 2018, 7月 13 火
    open var optionMultipleDateOutputFormat: WWCalendarTimeSelectorMultipleDateOutputFormat = .english
    
    public var globalColor: String = "#e61c40"
    
    // Fonts & Colors
    open var optionCalendarFontMonth = UIFont.systemFont(ofSize: 14)
    open var optionCalendarFontDays = UIFont.systemFont(ofSize: 13)
    open var optionCalendarFontDisabledDays = UIFont.systemFont(ofSize: 13)
    open var optionCalendarFontToday = UIFont.boldSystemFont(ofSize: 13)
    open var optionCalendarFontTodayHighlight = UIFont.boldSystemFont(ofSize: 14)
    open var optionCalendarFontPastDates = UIFont.systemFont(ofSize: 12)
    open var optionCalendarFontPastDatesHighlight = UIFont.systemFont(ofSize: 13)
    open var optionCalendarFontFutureDates = UIFont.systemFont(ofSize: 12)
    open var optionCalendarFontFutureDatesHighlight = UIFont.systemFont(ofSize: 13)
    
    open var optionCalendarFontColorMonth = UIColor.black
    open var optionCalendarFontColorDays = UIColor.black
    open var optionCalendarFontColorDisabledDays = UIColor.lightGray
    open var optionCalendarFontColorToday = UIColor.darkGray
    open var optionCalendarFontColorTodayHighlight = UIColor.white
    open var optionCalendarBackgroundColorTodayHighlight = UIColor.brown
    open var optionCalendarBackgroundColorTodayFlash = UIColor.white
    open var optionCalendarFontColorPastDates = UIColor.darkGray
    open var optionCalendarFontColorPastDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorPastDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorPastDatesFlash = UIColor.white
    open var optionCalendarFontColorFutureDates = UIColor.darkGray
    open var optionCalendarFontColorFutureDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorFutureDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorFutureDatesFlash = UIColor.white
    
    open var optionCalendarFontCurrentYear = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontCurrentYearHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorCurrentYear = UIColor.darkGray
    open var optionCalendarFontColorCurrentYearHighlight = UIColor.black
    open var optionCalendarFontPastYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontPastYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorPastYears = UIColor.darkGray
    open var optionCalendarFontColorPastYearsHighlight = UIColor.black
    open var optionCalendarFontFutureYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontFutureYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorFutureYears = UIColor.darkGray
    open var optionCalendarFontColorFutureYearsHighlight = UIColor.black
    
    open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
    open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
    open var optionClockFontColorAMPM = UIColor.black
    open var optionClockFontColorAMPMHighlight = UIColor.white
    open var optionClockBackgroundColorAMPMHighlight = UIColor.brown
    open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
    open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
    open var optionClockFontColorHour = UIColor.black
    open var optionClockFontColorHourHighlight = UIColor.white
    open var optionClockBackgroundColorHourHighlight = UIColor.brown
    open var optionClockBackgroundColorHourHighlightNeedle = UIColor.brown
    open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
    open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
    open var optionClockFontColorMinute = UIColor.black
    open var optionClockFontColorMinuteHighlight = UIColor.white
    open var optionClockBackgroundColorMinuteHighlight = UIColor.brown
    open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.brown
    open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
    open var optionClockBackgroundColorCenter = UIColor.black
    
    open var optionButtonShowCancel: Bool = false
    open var optionButtonTitleDone: String = "Done"
    open var optionButtonTitleCancel: String = "Cancel"
    open var optionButtonFontCancel = UIFont.systemFont(ofSize: 16)
    open var optionButtonFontDone = UIFont.boldSystemFont(ofSize: 16)
    open var optionButtonFontColorCancel = UIColor.brown
    open var optionButtonFontColorDone = UIColor.brown
    open var optionButtonFontColorCancelHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonFontColorDoneHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonBackgroundColorCancel = UIColor.clear
    open var optionButtonBackgroundColorDone = UIColor.clear
    
    open var optionLabelTextRangeTo: String = "To"
    
    open var optionTopPanelBackgroundColor = UIColor.brown
    open var optionTopPanelFont = UIFont.systemFont(ofSize: 16)
    open var optionTopPanelFontColor = UIColor.white
    
    open var optionSelectorPanelFontMonth = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontDate = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontYear = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontTime = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelection = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFont(ofSize: 17)
    open var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorMonthHighlight = UIColor.white
    open var optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorDateHighlight = UIColor.white
    open var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorYearHighlight = UIColor.white
    open var optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorTimeHighlight = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelection = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
    open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
    
    open var optionMainPanelBackgroundColor = UIColor.white
    open var optionBottomPanelBackgroundColor = UIColor.white
    
    /// Set global tint color.
    open var optionTintColor : UIColor! {
        get{
            return tintColor
        }
        set(color){
            tintColor = color;
            optionCalendarFontColorMonth = UIColor.black
            optionCalendarFontColorDays = UIColor.black
            optionCalendarFontColorDisabledDays = UIColor.lightGray
            optionCalendarFontColorToday = UIColor.darkGray
            optionCalendarFontColorTodayHighlight = UIColor.white
            optionCalendarBackgroundColorTodayHighlight = tintColor
            optionCalendarBackgroundColorTodayFlash = UIColor.white
            optionCalendarFontColorPastDates = UIColor.darkGray
            optionCalendarFontColorPastDatesHighlight = UIColor.white
            optionCalendarBackgroundColorPastDatesHighlight = tintColor
            optionCalendarBackgroundColorPastDatesFlash = UIColor.white
            optionCalendarFontColorFutureDates = UIColor.darkGray
            optionCalendarFontColorFutureDatesHighlight = UIColor.white
            optionCalendarBackgroundColorFutureDatesHighlight = tintColor
            optionCalendarBackgroundColorFutureDatesFlash = UIColor.white
            
            optionCalendarFontColorCurrentYear = UIColor.darkGray
            optionCalendarFontColorCurrentYearHighlight = UIColor.black
            optionCalendarFontColorPastYears = UIColor.darkGray
            optionCalendarFontColorPastYearsHighlight = UIColor.black
            optionCalendarFontColorFutureYears = UIColor.darkGray
            optionCalendarFontColorFutureYearsHighlight = UIColor.black
            
            optionClockFontColorAMPM = UIColor.black
            optionClockFontColorAMPMHighlight = UIColor.white
            optionClockBackgroundColorAMPMHighlight = tintColor
            optionClockFontColorHour = UIColor.black
            optionClockFontColorHourHighlight = UIColor.white
            optionClockBackgroundColorHourHighlight = tintColor
            optionClockBackgroundColorHourHighlightNeedle = tintColor
            optionClockFontColorMinute = UIColor.black
            optionClockFontColorMinuteHighlight = UIColor.white
            optionClockBackgroundColorMinuteHighlight = tintColor
            optionClockBackgroundColorMinuteHighlightNeedle = tintColor
            optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
            optionClockBackgroundColorCenter = UIColor.black
            
            optionButtonFontColorCancel = tintColor
            optionButtonFontColorDone = tintColor
            optionButtonFontColorCancelHighlight = tintColor.withAlphaComponent(0.25)
            optionButtonFontColorDoneHighlight = tintColor.withAlphaComponent(0.25)
            optionButtonBackgroundColorCancel = UIColor.clear
            optionButtonBackgroundColorDone = UIColor.clear
            
            optionTopPanelBackgroundColor = tintColor
            optionTopPanelFontColor = UIColor.white
            
            optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorMonthHighlight = UIColor.white
            optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorDateHighlight = UIColor.white
            optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorYearHighlight = UIColor.white
            optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorTimeHighlight = UIColor.white
            optionSelectorPanelFontColorMultipleSelection = UIColor.white
            optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
            optionSelectorPanelBackgroundColor = tintColor.withAlphaComponent(0.9)
            
            optionMainPanelBackgroundColor = UIColor.white
            optionBottomPanelBackgroundColor = UIColor.white
        }
    }

    
    /// This is the month's offset when user is in selection of dates mode. A positive number will adjusts the month higher, while a negative number will adjust the month lower.
    ///
    /// - Note:
    /// Defaults to 30.
    open var optionSelectorPanelOffsetHighlightMonth: CGFloat = 30
    
    /// This is the date's offset when user is in selection of dates mode. A positive number will adjusts the date lower, while a negative number will adjust the date higher.
    ///
    /// - Note:
    /// Defaults to 24.
    open var optionSelectorPanelOffsetHighlightDate: CGFloat = 24
    
    /// This is the scale of the month when it is in active view.
    open var optionSelectorPanelScaleMonth: CGFloat = 2.5
    open var optionSelectorPanelScaleDate: CGFloat = 4.5
    open var optionSelectorPanelScaleYear: CGFloat = 4
    open var optionSelectorPanelScaleTime: CGFloat = 2.75
    
    /// This is the height calendar's "title bar". If you wish to hide the Top Panel, consider `optionShowTopPanel`
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`
    open var optionLayoutTopPanelHeight: CGFloat = 28
    
    /// The height of the calendar in portrait mode. This will be translated automatically into the width in landscape mode.
    open var optionLayoutHeight: CGFloat?
    
    /// The width of the calendar in portrait mode. This will be translated automatically into the height in landscape mode.
    open var optionLayoutWidth: CGFloat?
    
    /// If optionLayoutHeight is not defined, this ratio is used on the screen's height.
    open var optionLayoutHeightRatio: CGFloat = 0.9
    
    /// If optionLayoutWidth is not defined, this ratio is used on the screen's width.
    open var optionLayoutWidthRatio: CGFloat = 0.85
    
    /// When calendar is in portrait mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 7 / 20
    open var optionLayoutPortraitRatio: CGFloat = 7/20
    
    /// When calendar is in landscape mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 3 / 8
    open var optionLayoutLandscapeRatio: CGFloat = 3/8
    
    // All Views
    @IBOutlet fileprivate weak var topContainerView: UIView!
    @IBOutlet fileprivate weak var bottomContainerView: UIView!
    @IBOutlet fileprivate weak var backgroundDayView: UIView!
    @IBOutlet fileprivate weak var backgroundSelView: UIView!
    @IBOutlet fileprivate weak var backgroundRangeView: UIView!
    @IBOutlet fileprivate weak var backgroundContentView: UIView!
    @IBOutlet fileprivate weak var backgroundButtonsView: UIView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var selDateView: UIView!
    @IBOutlet fileprivate weak var selYearView: UIView!
    @IBOutlet fileprivate weak var selTimeView: UIView!
    @IBOutlet fileprivate weak var selMultipleDatesTable: UITableView!
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    @IBOutlet fileprivate weak var monthLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var rangeStartLabel: UILabel!
    @IBOutlet fileprivate weak var rangeToLabel: UILabel!
    @IBOutlet fileprivate weak var rangeEndLabel: UILabel!
    @IBOutlet fileprivate weak var calendarTable: UITableView!
    @IBOutlet fileprivate weak var yearTable: UITableView!
    @IBOutlet fileprivate weak var clockView: WWClock!
    @IBOutlet fileprivate weak var monthsView: UIView!
    @IBOutlet fileprivate var monthsButtons: [UIButton]!
    
    // All Constraints
    @IBOutlet fileprivate weak var dayViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selMonthXConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selMonthYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateXConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeHeightConstraint: NSLayoutConstraint!
    
    // Private Variables
    fileprivate let selAnimationDuration: TimeInterval = 0.4
    fileprivate let selInactiveHeight: CGFloat = 48
    fileprivate var portraitContainerWidth: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var portraitTopContainerHeight: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutPortraitRatio : 0 }
    fileprivate var portraitBottomContainerHeight: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - portraitTopContainerHeight }
    fileprivate var landscapeContainerHeight: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var landscapeTopContainerWidth: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutLandscapeRatio : 0 }
    fileprivate var landscapeBottomContainerWidth: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - landscapeTopContainerWidth }
    fileprivate var selActiveHeight: CGFloat { return backgroundSelView.frame.height - selInactiveHeight }
    fileprivate var selInactiveWidth: CGFloat { return backgroundSelView.frame.width / 2 }
    fileprivate var selActiveWidth: CGFloat { return backgroundSelView.frame.height - selInactiveHeight }
    fileprivate var selCurrrent: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle(isSingular: true)
    fileprivate var isFirstLoad = false
    fileprivate var selTimeStateHour = true
    fileprivate var calRow1Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow2Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow3Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow1StartDate: Date = Date()
    fileprivate var calRow2StartDate: Date = Date()
    fileprivate var calRow3StartDate: Date = Date()
    fileprivate var yearRow1: Int = 2016
    fileprivate var multipleDates: [Date] { return optionCurrentDates.sorted(by: { $0.compare($1) == ComparisonResult.orderedAscending }) }
    fileprivate var multipleDatesLastAdded: Date?
    fileprivate var flashDate: Date?
    fileprivate let defaultTopPanelTitleForMultipleDates = "Select Multiple Dates"
    fileprivate var viewBoundsHeight: CGFloat {
        return view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length
    }
    fileprivate var viewBoundsWidth: CGFloat {
        return view.bounds.width
    }
    fileprivate var portraitHeight: CGFloat {
        return max(viewBoundsHeight, viewBoundsWidth)
    }
    fileprivate var portraitWidth: CGFloat {
        return min(viewBoundsHeight, viewBoundsWidth)
    }
    fileprivate var isSelectingStartRange: Bool = true { didSet { rangeStartLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDateHighlight : optionSelectorPanelFontColorDate; rangeEndLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDate : optionSelectorPanelFontColorDateHighlight } }
    fileprivate var shouldResetRange: Bool = true
    fileprivate var tintColor : UIColor! = UIColor.brown
    
    /// Only use this method to instantiate the selector. All customization should be done before presenting the selector to the user.
    /// To receive callbacks from selector, set the `delegate` of selector and implement `WWCalendarTimeSelectorProtocol`.
    ///
    ///     let selector = WWCalendarTimeSelector.instantiate()
    ///     selector.delegate = self
    ///     presentViewController(selector, animated: true, completion: nil)
    ///
    public static func instantiate() -> WWCalendarTimeSelector {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        var bundle: Bundle?
        if let bundleURL = bundleURL {
            bundle = Bundle(url: bundleURL)
        }
        return UIStoryboard(name: "WWCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! WWCalendarTimeSelector
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Take up the whole view when pushed from a navigation controller
        if navigationController != nil {
            optionLayoutWidthRatio = 1
            optionLayoutHeightRatio = 1
        }
        
        // Add background
        let background: UIView
        if navigationController != nil {
            background = UIView()
            background.backgroundColor = UIColor.white
        } else {
            background = UIVisualEffectView(effect: UIBlurEffect(style: optionStyleBlurEffect))
        }
        background.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(background, at: 0)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bg]|", options: [], metrics: nil, views: ["bg": background]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bg]|", options: [], metrics: nil, views: ["bg": background]))
        
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        
        yearRow1 = optionCurrentDate.year - 5
        
        selMultipleDatesTable.isHidden = optionSelectionType != .multiple
        backgroundSelView.isHidden = optionSelectionType != .single
        backgroundRangeView.isHidden = optionSelectionType != .range
        
        dayViewHeightConstraint.constant = optionShowTopPanel ? optionLayoutTopPanelHeight : 0
        view.layoutIfNeeded()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotateOrNot), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        backgroundDayView.backgroundColor = optionTopPanelBackgroundColor
        backgroundSelView.backgroundColor = optionSelectorPanelBackgroundColor
        backgroundRangeView.backgroundColor = optionSelectorPanelBackgroundColor
        backgroundContentView.backgroundColor = optionMainPanelBackgroundColor
        backgroundButtonsView.backgroundColor = optionBottomPanelBackgroundColor
        selMultipleDatesTable.backgroundColor = optionSelectorPanelBackgroundColor
        
        doneButton.backgroundColor = optionButtonBackgroundColorDone
        cancelButton.backgroundColor = optionButtonBackgroundColorCancel
        doneButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleDone, attributes: [NSAttributedString.Key.font: optionButtonFontDone, NSAttributedString.Key.foregroundColor: optionButtonFontColorDone]), for: UIControl.State())
        cancelButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleCancel, attributes: [NSAttributedString.Key.font: optionButtonFontCancel, NSAttributedString.Key.foregroundColor: optionButtonFontColorCancel]), for: UIControl.State())
        doneButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleDone, attributes: [NSAttributedString.Key.font: optionButtonFontDone, NSAttributedString.Key.foregroundColor: optionButtonFontColorDoneHighlight]), for: UIControl.State.highlighted)
        cancelButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleCancel, attributes: [NSAttributedString.Key.font: optionButtonFontCancel, NSAttributedString.Key.foregroundColor: optionButtonFontColorCancelHighlight]), for: UIControl.State.highlighted)
        
        rangeToLabel.text = optionLabelTextRangeTo
        
        if !optionButtonShowCancel {
            cancelButton.isHidden = true
        }
        
        dayLabel.textColor = optionTopPanelFontColor
        dayLabel.font = optionTopPanelFont
        monthLabel.font = optionSelectorPanelFontMonth
        dateLabel.font = optionSelectorPanelFontDate
        yearLabel.font = optionSelectorPanelFontYear
        rangeStartLabel.font = optionSelectorPanelFontDate
        rangeEndLabel.font = optionSelectorPanelFontDate
        rangeToLabel.font = optionSelectorPanelFontDate
        
        let firstMonth = Date().beginningOfYear
        for button in monthsButtons {
            button.setTitle((firstMonth + button.tag.month).stringFromFormat("MMM"), for: UIControl.State())
            button.titleLabel?.font = optionCalendarFontMonth
            button.tintColor = optionCalendarFontColorMonth
        }
        
        clockView.delegate = self
        clockView.minuteStep = optionTimeStep
        clockView.backgroundColorClockFace = optionClockBackgroundColorFace
        clockView.backgroundColorClockFaceCenter = optionClockBackgroundColorCenter
        clockView.fontAMPM = optionClockFontAMPM
        clockView.fontAMPMHighlight = optionClockFontAMPMHighlight
        clockView.fontColorAMPM = optionClockFontColorAMPM
        clockView.fontColorAMPMHighlight = optionClockFontColorAMPMHighlight
        clockView.backgroundColorAMPMHighlight = optionClockBackgroundColorAMPMHighlight
        clockView.fontHour = optionClockFontHour
        clockView.fontHourHighlight = optionClockFontHourHighlight
        clockView.fontColorHour = optionClockFontColorHour
        clockView.fontColorHourHighlight = optionClockFontColorHourHighlight
        clockView.backgroundColorHourHighlight = optionClockBackgroundColorHourHighlight
        clockView.backgroundColorHourHighlightNeedle = optionClockBackgroundColorHourHighlightNeedle
        clockView.fontMinute = optionClockFontMinute
        clockView.fontMinuteHighlight = optionClockFontMinuteHighlight
        clockView.fontColorMinute = optionClockFontColorMinute
        clockView.fontColorMinuteHighlight = optionClockFontColorMinuteHighlight
        clockView.backgroundColorMinuteHighlight = optionClockBackgroundColorMinuteHighlight
        clockView.backgroundColorMinuteHighlightNeedle = optionClockBackgroundColorMinuteHighlightNeedle
        
        updateDate()
        
        isFirstLoad = true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?
            calendarTable.reloadData()
            yearTable.reloadData()
            clockView.setNeedsDisplay()
            selMultipleDatesTable.reloadData()
            self.didRotateOrNot(animated: false)
            
            if optionStyles.showDateMonth {
                showDate(true, animated: false)
            }
            else if optionStyles.showMonth {
                showMonth(true, animated: false)
            }
            else if optionStyles.showYear {
                showYear(true, animated: false)
            }
            else if optionStyles.showTime {
                showTime(true, animated: false)
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstLoad = false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @objc internal func didRotateOrNot(animated: Bool = true) {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
            let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
            let size = CGSize(width: viewBoundsWidth, height: viewBoundsHeight)
            
            topContainerWidthConstraint.constant = isPortrait ? optionShowTopContainer ? portraitContainerWidth : 0 : landscapeTopContainerWidth
            topContainerHeightConstraint.constant = isPortrait ? portraitTopContainerHeight : optionShowTopContainer ? landscapeContainerHeight : 0
            bottomContainerWidthConstraint.constant = isPortrait ? portraitContainerWidth : landscapeBottomContainerWidth
            bottomContainerHeightConstraint.constant = isPortrait ? portraitBottomContainerHeight : landscapeContainerHeight
            
            if isPortrait {
                let width = min(size.width, size.height)
                let height = max(size.width, size.height)
                
                topContainerLeftConstraint.constant = (width - topContainerWidthConstraint.constant) / 2
                topContainerTopConstraint.constant = (height - (topContainerHeightConstraint.constant + bottomContainerHeightConstraint.constant)) / 2
                bottomContainerLeftConstraint.constant = optionShowTopContainer ? topContainerLeftConstraint.constant : (width - bottomContainerWidthConstraint.constant) / 2
                bottomContainerTopConstraint.constant = topContainerTopConstraint.constant + topContainerHeightConstraint.constant
            }
            else {
                let width = max(size.width, size.height)
                let height = min(size.width, size.height)
                
                topContainerLeftConstraint.constant = (width - (topContainerWidthConstraint.constant + bottomContainerWidthConstraint.constant)) / 2
                topContainerTopConstraint.constant = (height - topContainerHeightConstraint.constant) / 2
                bottomContainerLeftConstraint.constant = topContainerLeftConstraint.constant + topContainerWidthConstraint.constant
                bottomContainerTopConstraint.constant = optionShowTopContainer ? topContainerTopConstraint.constant : (height - bottomContainerHeightConstraint.constant) / 2
            }
            
            if animated {
                UIView.animate(
                    withDuration: selAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            } else {
                self.view.layoutIfNeeded()
            }
            
            if selCurrrent.showDateMonth {
                showDate(false, animated: animated)
            }
            else if selCurrrent.showMonth {
                showMonth(false, animated: animated)
            }
            else if selCurrrent.showYear {
                showYear(false, animated: animated)
            }
            else if selCurrrent.showTime {
                showTime(false, animated: animated)
            }
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func selectMonth(_ sender: UIButton) {
        let date = (optionCurrentDate.beginningOfYear + sender.tag.months).beginningOfDay
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day).beginningOfDay
            updateDate()
        }
    }
    
    @IBAction func selectStartRange() {
        if isSelectingStartRange == true {
            let date = optionCurrentDateRange.start
            
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else {
            isSelectingStartRange = true
        }
        shouldResetRange = false
        updateDate()
    }
    
    @IBAction func selectEndRange() {
        if isSelectingStartRange == false {
            let date = optionCurrentDateRange.end
            
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else {
            isSelectingStartRange = false
        }
        shouldResetRange = false
        updateDate()
    }
    
    @IBAction func showDate() {
        if optionStyles.showDateMonth {
            showDate(true)
        }
        else {
            showMonth(true)
        }
    }
    
    @IBAction func showYear() {
        showYear(true)
    }
    
    @IBAction func showTime() {
        showTime(true)
    }
    
    @IBAction func cancel() {
        let picker = self
        let del = delegate
        if optionSelectionType == .single {
            del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        }
        else {
            del?.WWCalendarTimeSelectorCancel?(picker, dates: multipleDates)
        }
        dismiss()
    }
    
    @IBAction func done() {
        let picker = self
        let del = delegate
        switch optionSelectionType {
        case .single:
            del?.WWCalendarTimeSelectorDone?(picker, date: optionCurrentDate)
        case .multiple:
            del?.WWCalendarTimeSelectorDone?(picker, dates: multipleDates)
        case .range:
            del?.WWCalendarTimeSelectorDone?(picker, dates: optionCurrentDateRange.array)
        }
        dismiss()
    }
    
    fileprivate func dismiss() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        } else if presentingViewController != nil {
            dismiss(animated: true) {
                del?.WWCalendarTimeSelectorDidDismiss?(picker)
            }
        }
    }
    
    fileprivate func showDate(_ userTap: Bool, animated: Bool = true) {
        changeSelDate(animated: animated)
        
        if userTap {
            let seventhRowStartDate = optionCurrentDate.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.top, animated: animated)
        }
        else {
            calendarTable.reloadData()
        }
        
        let animations = {
            self.calendarTable.alpha = 1
            self.monthsView.alpha = 0
            self.yearTable.alpha = 0
            self.clockView.alpha = 0
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
                animations: animations,
                completion: nil
            )
        } else {
            animations()
        }
    }
    
    fileprivate func showMonth(_ userTap: Bool, animated: Bool = true) {
        changeSelMonth(animated: animated)
        
        if userTap {
            
        }
        else {
            
        }
        
        let animations = {
            self.calendarTable.alpha = 0
            self.monthsView.alpha = 1
            self.yearTable.alpha = 0
            self.clockView.alpha = 0
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
                animations: animations,
                completion: nil
            )
        } else {
            animations()
        }
    }
    
    fileprivate func showYear(_ userTap: Bool, animated: Bool = true) {
        changeSelYear(animated: animated)
        
        if userTap {
            yearRow1 = optionCurrentDate.year - 5
            yearTable.reloadData()
            yearTable.scrollToRow(at: IndexPath(row: 3, section: 0), at: UITableView.ScrollPosition.top, animated: animated)
        }
        else {
            yearTable.reloadData()
        }
        
        let animations = {
            self.calendarTable.alpha = 0
            self.monthsView.alpha = 0
            self.yearTable.alpha = 1
            self.clockView.alpha = 0
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
                animations: animations,
                completion: nil
            )
        } else {
            animations()
        }
    }
    
    fileprivate func showTime(_ userTap: Bool, animated: Bool = true) {
        if userTap {
            if selCurrrent.showTime {
                selTimeStateHour = !selTimeStateHour
            }
            else {
                selTimeStateHour = true
            }
        }
        
        if optionTimeStep == .sixtyMinutes {
            selTimeStateHour = true
        }
        
        changeSelTime(animated: animated)
        
        if userTap {
            clockView.showingHour = selTimeStateHour
        }
        clockView.setNeedsDisplay()
        
        if animated {
            UIView.transition(
                with: clockView,
                duration: selAnimationDuration / 2,
                options: [UIView.AnimationOptions.transitionCrossDissolve],
                animations: {
                    self.clockView.layer.displayIfNeeded()
                },
                completion: nil
            )
        } else {
            self.clockView.layer.displayIfNeeded()
        }
        
        let animations = {
            self.calendarTable.alpha = 0
            self.monthsView.alpha = 0
            self.yearTable.alpha = 0
            self.clockView.alpha = 1
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseOut],
                animations: animations,
                completion: nil
            )
        } else {
            animations()
        }
    }
    
    fileprivate func updateDate() {
        if let topPanelTitle = optionTopPanelTitle {
            dayLabel.text = topPanelTitle
        }
        else {
            if optionSelectionType == .single {
                if optionStyles.showMonth {
                    dayLabel.text = optionCurrentDate.stringFromFormat("MMMM")
                }
                else {
                    dayLabel.text = optionCurrentDate.stringFromFormat("EEEE")
                }
            }
            else {
                dayLabel.text = defaultTopPanelTitleForMultipleDates
            }
        }
        
        monthLabel.text = optionCurrentDate.stringFromFormat("MMM")
        dateLabel.text = optionStyles.showDateMonth ? optionCurrentDate.stringFromFormat("d") : nil
        yearLabel.text = optionCurrentDate.stringFromFormat("yyyy")
        rangeStartLabel.text = optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")
        rangeEndLabel.text = optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")
        rangeToLabel.textColor = optionSelectorPanelFontColorDate
        if shouldResetRange {
            rangeStartLabel.textColor = optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
        }
        else {
            rangeStartLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDateHighlight : optionSelectorPanelFontColorDate
            rangeEndLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDate : optionSelectorPanelFontColorDateHighlight
        }
        
        let timeText = optionCurrentDate.stringFromFormat("h':'mma").lowercased()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        let attrText = NSMutableAttributedString(string: timeText, attributes: [NSAttributedString.Key.font: optionSelectorPanelFontTime, NSAttributedString.Key.foregroundColor: optionSelectorPanelFontColorTime, NSAttributedString.Key.paragraphStyle: paragraph])
        
        if selCurrrent.showDateMonth {
            monthLabel.textColor = optionSelectorPanelFontColorMonthHighlight
            dateLabel.textColor = optionSelectorPanelFontColorDateHighlight
            yearLabel.textColor = optionSelectorPanelFontColorYear
        }
        else if selCurrrent.showMonth {
            monthLabel.textColor = optionSelectorPanelFontColorMonthHighlight
            dateLabel.textColor = optionSelectorPanelFontColorDateHighlight
            yearLabel.textColor = optionSelectorPanelFontColorYear
        }
        else if selCurrrent.showYear {
            monthLabel.textColor = optionSelectorPanelFontColorMonth
            dateLabel.textColor = optionSelectorPanelFontColorDate
            yearLabel.textColor = optionSelectorPanelFontColorYearHighlight
        }
        else if selCurrrent.showTime {
            monthLabel.textColor = optionSelectorPanelFontColorMonth
            dateLabel.textColor = optionSelectorPanelFontColorDate
            yearLabel.textColor = optionSelectorPanelFontColorYear
            
            
//            let colonIndex2 = timeText.characters.distance(from: timeText.startIndex, to: timeText.range(of: ":")!.lowerBound)
            let colonIndex = Substring(timeText).distance(from: timeText.startIndex, to: timeText.range(of: ":")!.lowerBound)
            let hourRange = NSRange(location: 0, length: colonIndex)
            let minuteRange = NSRange(location: colonIndex + 1, length: 2)
            
            if selTimeStateHour {
                attrText.addAttributes([NSAttributedString.Key.foregroundColor: optionSelectorPanelFontColorTimeHighlight], range: hourRange)
            }
            else {
                attrText.addAttributes([NSAttributedString.Key.foregroundColor: optionSelectorPanelFontColorTimeHighlight], range: minuteRange)
            }
        }
        timeLabel.attributedText = attrText
    }
    
    fileprivate func changeSelDate(animated: Bool = true) {
        let selActiveHeight = self.selActiveHeight
        let selInactiveHeight = self.selInactiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = backgroundSelView.frame.height
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        // adjust date view (because it's complicated)
        selMonthXConstraint.constant = 0
        selMonthYConstraint.constant = -optionSelectorPanelOffsetHighlightMonth
        selDateXConstraint.constant = 0
        selDateYConstraint.constant = optionSelectorPanelOffsetHighlightDate
        
        // adjust positions
        selDateTopConstraint.constant = 0
        selDateLeftConstraint.constant = 0
        selDateRightConstraint.constant = 0
        selDateHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selYearLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        if optionStyles.showYear {
            selYearTopConstraint.constant = selActiveHeight
            selYearHeightConstraint.constant = selInactiveHeight
            if optionStyles.showTime {
                selYearRightConstraint.constant = selInactiveWidth
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = selInactiveWidth
            }
            else {
                selYearRightConstraint.constant = 0
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selYearTopConstraint.constant = 0
            selYearHeightConstraint.constant = 0
            selYearRightConstraint.constant = selInactiveWidthDouble
            if optionStyles.showTime {
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = 0
            }
            else {
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        monthLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleMonth
        dateLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleDate
        let animations = {
            self.monthLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleMonth, y: self.optionSelectorPanelScaleMonth)
            self.dateLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleDate, y: self.optionSelectorPanelScaleDate)
            self.yearLabel.transform = CGAffineTransform.identity
            self.timeLabel.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
        let completion = { (_: Bool) in
            if self.selCurrrent.showDateMonth {
                self.yearLabel.contentScaleFactor = UIScreen.main.scale
                self.timeLabel.contentScaleFactor = UIScreen.main.scale
            }
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
        selCurrrent.showDateMonth(true)
        updateDate()
    }
    
    fileprivate func changeSelMonth(animated: Bool = true) {
        let selActiveHeight = self.selActiveHeight
        let selInactiveHeight = self.selInactiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = backgroundSelView.frame.height
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        // adjust date view
        selMonthXConstraint.constant = 0
        selMonthYConstraint.constant = 0
        selDateXConstraint.constant = 0
        selDateYConstraint.constant = 0
        
        // adjust positions
        selDateTopConstraint.constant = 0
        selDateLeftConstraint.constant = 0
        selDateRightConstraint.constant = 0
        selDateHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selYearLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        if optionStyles.showYear {
            selYearTopConstraint.constant = selActiveHeight
            selYearHeightConstraint.constant = selInactiveHeight
            if optionStyles.showTime {
                selYearRightConstraint.constant = selInactiveWidth
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = selInactiveWidth
            }
            else {
                selYearRightConstraint.constant = 0
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selYearTopConstraint.constant = 0
            selYearHeightConstraint.constant = 0
            selYearRightConstraint.constant = selInactiveWidthDouble
            if optionStyles.showTime {
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = 0
            }
            else {
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        monthLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleMonth
        dateLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleDate
        let animations = {
            self.monthLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleMonth, y: self.optionSelectorPanelScaleMonth)
            self.dateLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleDate, y: self.optionSelectorPanelScaleDate)
            self.yearLabel.transform = CGAffineTransform.identity
            self.timeLabel.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
        let completion = { (_: Bool) in
            if self.selCurrrent.showMonth {
                self.yearLabel.contentScaleFactor = UIScreen.main.scale
                self.timeLabel.contentScaleFactor = UIScreen.main.scale
            }
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
        selCurrrent.showDateMonth(true)
        updateDate()
    }
    
    fileprivate func changeSelYear(animated: Bool = true) {
        let selInactiveHeight = self.selInactiveHeight
        let selActiveHeight = self.selActiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selMonthX = monthLabel.bounds.width / 2
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = backgroundSelView.frame.height
        
        backgroundSelView.sendSubviewToBack(selDateView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        selDateXConstraint.constant = optionStyles.showDateMonth ? -selMonthX : 0
        selDateYConstraint.constant = 0
        selMonthXConstraint.constant = optionStyles.showDateMonth ? selMonthX : 0
        selMonthYConstraint.constant = 0
        
        selYearTopConstraint.constant = 0
        selYearLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        selYearHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selDateLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        
        if optionStyles.showDateMonth || optionStyles.showMonth {
            selDateHeightConstraint.constant = selInactiveHeight
            selDateTopConstraint.constant = selActiveHeight
            if optionStyles.showTime {
                selDateRightConstraint.constant = selInactiveWidth
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = selInactiveWidth
            }
            else {
                selDateRightConstraint.constant = 0
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            selDateRightConstraint.constant = selInactiveWidthDouble
            if optionStyles.showTime {
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = 0
            }
            else {
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        yearLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleYear
        let animations = {
            self.yearLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleYear, y: self.optionSelectorPanelScaleYear)
            self.monthLabel.transform = CGAffineTransform.identity
            self.dateLabel.transform = CGAffineTransform.identity
            self.timeLabel.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
        let completion = { (_: Bool) in
            if self.selCurrrent.showYear {
                self.monthLabel.contentScaleFactor = UIScreen.main.scale
                self.dateLabel.contentScaleFactor = UIScreen.main.scale
                self.timeLabel.contentScaleFactor = UIScreen.main.scale
            }
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
        selCurrrent.showYear(true)
        updateDate()
    }
    
    fileprivate func changeSelTime(animated: Bool = true) {
        let selInactiveHeight = self.selInactiveHeight
        let selActiveHeight = self.selActiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selMonthX = monthLabel.bounds.width / 2
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = backgroundSelView.frame.height
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selDateView)
        
        selDateXConstraint.constant = optionStyles.showDateMonth ? -selMonthX : 0
        selDateYConstraint.constant = 0
        selMonthXConstraint.constant = optionStyles.showDateMonth ? selMonthX : 0
        selMonthYConstraint.constant = 0
        
        selTimeTopConstraint.constant = 0
        selTimeLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        selTimeHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selDateLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        if optionStyles.showDateMonth || optionStyles.showMonth {
            selDateHeightConstraint.constant = selInactiveHeight
            selDateTopConstraint.constant = selActiveHeight
            if optionStyles.showYear {
                selDateRightConstraint.constant = selInactiveWidth
                selYearHeightConstraint.constant = selInactiveHeight
                selYearTopConstraint.constant = selActiveHeight
                selYearLeftConstraint.constant = selInactiveWidth
            }
            else {
                selDateRightConstraint.constant = 0
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
                selYearLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            selDateRightConstraint.constant = selInactiveWidthDouble
            if optionStyles.showYear {
                selYearHeightConstraint.constant = selInactiveHeight
                selYearTopConstraint.constant = selActiveHeight
                selYearLeftConstraint.constant = 0
            }
            else {
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
                selYearLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        timeLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleTime
        let animations = {
            self.timeLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleTime, y: self.optionSelectorPanelScaleTime)
            self.monthLabel.transform = CGAffineTransform.identity
            self.dateLabel.transform = CGAffineTransform.identity
            self.yearLabel.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
        let completion = { (_: Bool) in
            if self.selCurrrent.showTime {
                self.monthLabel.contentScaleFactor = UIScreen.main.scale
                self.dateLabel.contentScaleFactor = UIScreen.main.scale
                self.yearLabel.contentScaleFactor = UIScreen.main.scale
            }
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIView.AnimationOptions.allowAnimatedContent, UIView.AnimationOptions.allowUserInteraction],
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
        selCurrrent.showTime(true)
        updateDate()
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == calendarTable {
            return tableView.frame.height / 8
        }
        else if tableView == yearTable {
            return tableView.frame.height / 5
        }
        return tableView.frame.height / 5
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == calendarTable {
            return 16
        }
        else if tableView == yearTable {
            return 11
        }
        return multipleDates.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView == calendarTable {
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                let calRow = WWCalendarRow()
                calRow.translatesAutoresizingMaskIntoConstraints = false
                calRow.delegate = self
                calRow.backgroundColor = UIColor.clear
                calRow.monthFont = optionCalendarFontMonth
                calRow.monthFontColor = optionCalendarFontColorMonth
                calRow.dayFont = optionCalendarFontDays
                calRow.dayFontColor = optionCalendarFontColorDays
                calRow.dateDisableFontColor = optionCalendarFontColorDisabledDays
                calRow.dateDisableFont = optionCalendarFontDisabledDays
                calRow.datePastFont = optionCalendarFontPastDates
                calRow.datePastFontHighlight = optionCalendarFontPastDatesHighlight
                calRow.datePastFontColor = optionCalendarFontColorPastDates
                calRow.datePastHighlightFontColor = optionCalendarFontColorPastDatesHighlight
                calRow.datePastHighlightBackgroundColor = optionCalendarBackgroundColorPastDatesHighlight
                calRow.datePastFlashBackgroundColor = optionCalendarBackgroundColorPastDatesFlash
                calRow.dateTodayFont = optionCalendarFontToday
                calRow.dateTodayFontHighlight = optionCalendarFontTodayHighlight
                calRow.dateTodayFontColor = optionCalendarFontColorToday
                calRow.dateTodayHighlightFontColor = optionCalendarFontColorTodayHighlight
                calRow.dateTodayHighlightBackgroundColor = optionCalendarBackgroundColorTodayHighlight
                calRow.dateTodayFlashBackgroundColor = optionCalendarBackgroundColorTodayFlash
                calRow.dateFutureFont = optionCalendarFontFutureDates
                calRow.dateFutureFontHighlight = optionCalendarFontFutureDatesHighlight
                calRow.dateFutureFontColor = optionCalendarFontColorFutureDates
                calRow.dateFutureHighlightFontColor = optionCalendarFontColorFutureDatesHighlight
                calRow.dateFutureHighlightBackgroundColor = optionCalendarBackgroundColorFutureDatesHighlight
                calRow.dateFutureFlashBackgroundColor = optionCalendarBackgroundColorFutureDatesFlash
                calRow.flashDuration = selAnimationDuration
                calRow.multipleSelectionGrouping = optionMultipleSelectionGrouping
                calRow.multipleSelectionEnabled = optionSelectionType != .single
                cell.contentView.addSubview(calRow)
                cell.backgroundColor = UIColor.clear
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
            }
            
            for sv in cell.contentView.subviews {
                if let calRow = sv as? WWCalendarRow {
                    calRow.tag = (indexPath as NSIndexPath).row + 1
                    switch optionSelectionType {
                    case .single:
                        calRow.selectedDates = [optionCurrentDate]
                    case .multiple:
                        calRow.selectedDates = optionCurrentDates
                    case .range:
                        calRow.selectedDates = Set(optionCurrentDateRange.array)
                    }
                    calRow.setNeedsDisplay()
                    if let fd = flashDate {
                        if calRow.flashDate(fd) {
                            flashDate = nil
                        }
                    }
                }
            }
        }
        else if tableView == yearTable {
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            }
            
            let currentYear = Date().year
            let displayYear = yearRow1 + (indexPath as NSIndexPath).row
            if displayYear > currentYear {
                cell.textLabel?.font = optionCurrentDate.year == displayYear ? optionCalendarFontFutureYearsHighlight : optionCalendarFontFutureYears
                cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionCalendarFontColorFutureYearsHighlight : optionCalendarFontColorFutureYears
            }
            else if displayYear < currentYear {
                cell.textLabel?.font = optionCurrentDate.year == displayYear ? optionCalendarFontPastYearsHighlight : optionCalendarFontPastYears
                cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionCalendarFontColorPastYearsHighlight : optionCalendarFontColorPastYears
            }
            else {
                cell.textLabel?.font = optionCurrentDate.year == displayYear ? optionCalendarFontCurrentYearHighlight : optionCalendarFontCurrentYear
                cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionCalendarFontColorCurrentYearHighlight : optionCalendarFontColorCurrentYear
            }
            cell.textLabel?.text = "\(displayYear)"
        }
        else { // multiple dates table
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.backgroundColor = UIColor.clear
            }
            
            let date = multipleDates[(indexPath as NSIndexPath).row]
            cell.textLabel?.font = date == multipleDatesLastAdded ? optionSelectorPanelFontMultipleSelectionHighlight : optionSelectorPanelFontMultipleSelection
            cell.textLabel?.textColor = date == multipleDatesLastAdded ? optionSelectorPanelFontColorMultipleSelectionHighlight : optionSelectorPanelFontColorMultipleSelection

            // output date format
            switch optionMultipleDateOutputFormat {
            case .english:
                cell.textLabel?.text = date.stringFromFormat("EEE', 'd' 'MMM' 'yyyy")
            case .japanese:
                cell.textLabel?.text = date.stringFromFormat("yyyy'年 'MMM' 'd'日 'EEE")
            }
            
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == yearTable {
            let displayYear = yearRow1 + (indexPath as NSIndexPath).row
            if let newDate = optionCurrentDate.change(year: displayYear),
                WWCalendarRowDateIsEnable(newDate),
                delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: newDate) ?? true {
                optionCurrentDate = newDate
                updateDate()
                tableView.reloadData()
            }
        }
        else if tableView == selMultipleDatesTable {
            let date = multipleDates[(indexPath as NSIndexPath).row]
            multipleDatesLastAdded = date
            selMultipleDatesTable.reloadData()
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if scrollView == calendarTable {
            let twoRow = backgroundContentView.frame.height / 4
            if offsetY < twoRow {
                // every row shift by 4 to the back, recalculate top 3 towards earlier dates
                
                let detail1 = WWCalendarRowGetDetails(-3)
                let detail2 = WWCalendarRowGetDetails(-2)
                let detail3 = WWCalendarRowGetDetails(-1)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + twoRow * 2)
                calendarTable.reloadData()
            }
            else if offsetY > twoRow * 3 {
                // every row shift by 4 to the front, recalculate top 3 towards later dates
                
                let detail1 = WWCalendarRowGetDetails(5)
                let detail2 = WWCalendarRowGetDetails(6)
                let detail3 = WWCalendarRowGetDetails(7)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - twoRow * 2)
                calendarTable.reloadData()
            }
        }
        else if scrollView == yearTable {
            let triggerPoint = backgroundContentView.frame.height / 10 * 3
            if offsetY < triggerPoint {
                yearRow1 = yearRow1 - 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + triggerPoint * 2)
                yearTable.reloadData()
            }
            else if offsetY > triggerPoint * 3 {
                yearRow1 = yearRow1 + 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - triggerPoint * 2)
                yearTable.reloadData()
            }
        }
    }
    
    internal func WWCalendarRowDateIsEnable(_ date: Date) -> Bool {
        if let fromDate = optionRangeOfEnabledDates.start,
            date.compare(fromDate) == .orderedAscending {
            return false
        }
        if let toDate = optionRangeOfEnabledDates.end,
            date.compare(toDate) == .orderedDescending {
            return false
        }
        return true
    }
    
    // CAN DO BETTER! TOO MANY LOOPS!
    internal func WWCalendarRowGetDetails(_ row: Int) -> (type: WWCalendarRowType, startDate: Date) {
        if row == 1 {
            return (calRow1Type, calRow1StartDate)
        }
        else if row == 2 {
            return (calRow2Type, calRow2StartDate)
        }
        else if row == 3 {
            return (calRow3Type, calRow3StartDate)
        }
        else if row > 3 {
            var startRow: Int
            var startDate: Date
            var rowType: WWCalendarRowType
            if calRow3Type == .date {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            
            for _ in startRow..<row {
                if rowType == .month {
                    rowType = .day
                }
                else if rowType == .day {
                    rowType = .date
                    startDate = startDate.beginningOfMonth
                }
                else {
                    let newStartDate = startDate.endOfWeek + 1.day
                    if newStartDate.month != startDate.month {
                        rowType = .month
                    }
                    startDate = newStartDate
                }
            }
            return (rowType, startDate)
        }
        else {
            // row <= 0
            var startRow: Int
            var startDate: Date
            var rowType: WWCalendarRowType
            if calRow1Type == .date {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            
            for _ in row..<startRow {
                if rowType == .date {
                    if startDate.day == 1 {
                        rowType = .day
                    }
                    else {
                        let newStartDate = (startDate - 1.day).beginningOfWeek
                        if newStartDate.month != startDate.month {
                            startDate = startDate.beginningOfMonth
                        }
                        else {
                            startDate = newStartDate
                        }
                    }
                }
                else if rowType == .day {
                    rowType = .month
                }
                else {
                    rowType = .date
                    startDate = (startDate - 1.day).beginningOfWeek
                }
            }
            return (rowType, startDate)
        }
    }
    
    internal func WWCalendarRowDidSelect(_ date: Date) {
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            switch optionSelectionType {
            case .single:
                optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)
                updateDate()
                
            case .multiple:
                var indexPath: IndexPath
                var indexPathToReload: IndexPath? = nil
                
                if let d = multipleDatesLastAdded {
                    let indexToReload = multipleDates.index(of: d)!
                    indexPathToReload = IndexPath(row: indexToReload, section: 0)
                }
                
                if let indexToDelete = multipleDates.index(of: date) {
                    // delete...
                    indexPath = IndexPath(row: indexToDelete, section: 0)
                    optionCurrentDates.remove(date)
                    
                    selMultipleDatesTable.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
                    
                    multipleDatesLastAdded = nil
                    selMultipleDatesTable.beginUpdates()
                    selMultipleDatesTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                    if let ip = indexPathToReload , ip != indexPath {
                        selMultipleDatesTable.reloadRows(at: [ip], with: UITableView.RowAnimation.fade)
                    }
                    selMultipleDatesTable.endUpdates()
                }
                else {
                    // insert...
                    var shouldScroll = false
                    
                    optionCurrentDates.insert(date)
                    let indexToAdd = multipleDates.index(of: date)!
                    indexPath = IndexPath(row: indexToAdd, section: 0)
                    
                    if indexPath.row < optionCurrentDates.count - 1 {
                        selMultipleDatesTable.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
                    }
                    else {
                        shouldScroll = true
                    }
                    
                    multipleDatesLastAdded = date
                    selMultipleDatesTable.beginUpdates()
                    selMultipleDatesTable.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
                    if let ip = indexPathToReload {
                        selMultipleDatesTable.reloadRows(at: [ip], with: UITableView.RowAnimation.fade)
                    }
                    selMultipleDatesTable.endUpdates()
                    
                    if shouldScroll {
                        selMultipleDatesTable.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
                    }
                }
                
            case .range:
                
                let rangeDate = date.beginningOfDay
                if shouldResetRange {
                    optionCurrentDateRange.setStartDate(rangeDate)
                    optionCurrentDateRange.setEndDate(rangeDate)
                    isSelectingStartRange = false
                    shouldResetRange = false
                }
                else {
                    if isSelectingStartRange {
                        optionCurrentDateRange.setStartDate(rangeDate)
                        isSelectingStartRange = false
                    }
                    else {
                        let date0 : Date = rangeDate
                        let date1 : Date = optionCurrentDateRange.start
                        optionCurrentDateRange.setStartDate(min(date0, date1))
                        optionCurrentDateRange.setEndDate(max(date0, date1))
                        shouldResetRange = true
                    }
                }
                updateDate()
            }
            calendarTable.reloadData()
        }
    }
    
    internal func WWClockGetTime() -> Date {
        return optionCurrentDate
    }
    
    internal func WWClockSwitchAMPM(isAM: Bool, isPM: Bool) {
        var newHour = optionCurrentDate.hour
        if isAM && newHour >= 12 {
            newHour = newHour - 12
        }
        if isPM && newHour < 12 {
            newHour = newHour + 12
        }
        
        optionCurrentDate = optionCurrentDate.change(hour: newHour)
        updateDate()
        clockView.setNeedsDisplay()
        UIView.transition(
            with: clockView,
            duration: selAnimationDuration / 2,
            options: [UIView.AnimationOptions.transitionCrossDissolve, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState],
            animations: {
                self.clockView.layer.displayIfNeeded()
            },
            completion: nil
        )
    }
    
    internal func WWClockSetHourMilitary(_ hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        updateDate()
        clockView.setNeedsDisplay()
    }
    
    internal func WWClockSetMinute(_ minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        updateDate()
        clockView.setNeedsDisplay()
    }
}
