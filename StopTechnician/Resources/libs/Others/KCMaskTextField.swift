//
//  DateTextField.swift
//  DateTextFieldDemo
//
//  Created by Arshad KC.
//  Copyright © 2016 Arshad KC. All rights reserved.
//

import Foundation
import UIKit

enum KCMaskTextFieldStatus {
    case clear
    case incomplete
    case complete
}

struct Delimiter {
    static let value:Character = "*"
}

struct KCChar {
    var format:Character
    var value:Character
    var isClear:Bool
    var type:Character

    init(format:Character, type:Character) {
        self.format = format
        self.value = format
        self.type = type
        self.isClear = true
    }
    
    var isEditable:Bool {
        return type != Delimiter.value
    }
}

class KCMaskTextField: UITextField {
    // Private
    fileprivate var chars:Array<KCChar> = Array<KCChar>()
    fileprivate var previousCursorPosition = 0
    
    // Delegate
    var maskDelegate: KCMaskFieldDelegate?
    
    // Color for mask values. ex: DD,MM and YY in DD/MM/YY
    @IBInspectable var formatColor:UIColor = UIColor.gray{
        didSet {
            displayFormattedText()
            moveCursorTo(previousCursorPosition)
        }
    }
    
    // Color for delimiterColor values. ex: /,/ in DD/MM/YY
    @IBInspectable var delimiterColor:UIColor = UIColor.gray{
        didSet {
            displayFormattedText()
            moveCursorTo(previousCursorPosition)
        }
    }
    
    // Color for editable values. ex: 22,01,17 in 22/01/17
    @IBInspectable var editableColor:UIColor = UIColor.black{
        didSet {
            displayFormattedText()
            moveCursorTo(previousCursorPosition)
        }
    }
    
    // Format string. ex: MM/DD/YYYY
    @IBInspectable var formatString:String = "" {
        didSet {
            initialize()
        }
    }
    
    //     d	: Number, decimal number from 0 to 9
    //     D	: Any symbol, except decimal number
    //     a	: Alphabetic symbol, a-Z
    //     A	: Not an alphabetic symbol
    //     c    : Alphanumeric a-z,0-9
    //     C    : Not an alphanumeric symbol
    //     h	: Hexadecimal symbol
    //     .	: Corresponds to any symbol (default)
    //     *	: Non editable field

    // Mask string. ex: dd*dd*dd
    @IBInspectable var maskString:String = "" {
        didSet {
            initialize()
        }
    }
    
    ///     a	: Display in lower case
    ///     A	: Display in upper case
    @IBInspectable var caseString:String = "" {
        didSet {
        }
    }

    fileprivate func initialize() {
        // Set delegate ot self
        self.delegate = self
        chars.removeAll()
        for (index,c) in formatString.enumerated() {
            // Create KCChar
            let m = index < maskString.count ? maskString[formatString.index(formatString.startIndex, offsetBy: index)] : "."
            let sq = KCChar(format: c, type:m)
            chars.append(sq)
        }
        // Display formation
        displayFormattedText()
        // Set initial cursor position
        previousCursorPosition = findLocationForward(fromLocation: 0) ?? 0
    }
}

// MARK: - Public methods
extension KCMaskTextField {
    /**
     Returns status of the mask field (.Clear, .InComplete, .Complete ).
     */
    func status() -> KCMaskTextFieldStatus {
        let editableChars = chars.filter {$0.isEditable}
        let completedChar = editableChars.filter {!$0.isClear}.count
        return completedChar == editableChars.count ? .complete : completedChar == 0 ? .clear : .incomplete
    }

    /**
     Returns an array of values for each component.
     */
    func textComponents() -> [String] {
        var components = [String]()
        var str = String()
        var count  = 0
        for (index,ch) in chars.enumerated() {
            if ch.isEditable {
                str = str + (ch.isClear ? "" : String(ch.value))
                count += 1
            }
            if (!ch.isEditable || index == chars.count - 1 ) && count > 0 {
                components.append(str)
                str.removeAll()
                count = 0
                continue
            }
        }
        return components
    }
    
    /**
     Returns the string displayed in the mask field as it is.
     */
    func rawText() -> String {
        return chars.map {String($0.value)}.reduce("", {$0 + $1})
    }
    
    /**
     Returns the values entered in mask field.
     */
    func editedText() -> String {
        return chars.filter{$0.isEditable && !$0.isClear}.map{String($0.value)}.reduce("", {$0 + $1})
    }
    
    /**
     Updates the text
     */
    func updateText(_ text:String) {
        guard text.count > 0 else {
            return
        }
        _ = textField(self, shouldChangeCharactersIn: NSMakeRange(0,0), replacementString: text)
    }
    
    /**
     Clears the text. This does not clear any format/mask/case.
     */
    func clearText() {
        for (index,ch) in chars.enumerated() {
            if !ch.isClear {
                chars[index].value = chars[index].format
                chars[index].isClear = true
            }
        }
        displayFormattedText()
        previousCursorPosition = findLocationForward(fromLocation: 0) ?? 0
        moveCursorTo(previousCursorPosition)
    }
    
    /**
     Sets format and mask for mask field
     */
    func setFormat(_ format:String, mask:String) {
        formatString = format
        maskString = mask
    }
}

//  MARK: - Textfield Delegate
extension KCMaskTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveCursorTo(previousCursorPosition)
        maskDelegate?.maskFieldDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        maskDelegate?.maskFieldDidEndEditing(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // guard out of bounds
        guard range.location < chars.count else {
            return false
        }
        formatInput(string, range: range)
        return false
    }
    
    fileprivate func formatInput(_ string:String, range:NSRange) {
        var nextCursorPosition = range.location
        let inputLength = string.count
        var edited = false
        // Edit
        if (inputLength > 0) {
            let hasSelection = range.length > 0 && range.length < string.count
            var nextValidLocation:Int = range.location;
            let start = range.location
            let end = start + (range.length == 0 ? string.count : range.length >= string.count ? string.count : range.length)
            var index = 0
            for _ in start ..< end{
                let c = string[string.index(string.startIndex, offsetBy: index)]
                if let location = findLocationForward(fromLocation: nextValidLocation) {
                    if hasSelection && location >= end {
                        break
                    }
                    if isValidCharacter(c, atIndex: location) {
                        chars[location].value = c
                        chars[location].isClear = false
                        edited = true
                        nextValidLocation  = location + 1
                    }
                }
                index+=1
            }
            
            // If there is any insertion or replacement, update the display and cursor.
            if (edited) {
                displayFormattedText()
                nextCursorPosition = nextValidLocation
            }
        }
        // Delete & Replace
        else {
            // Clear
            let start = range.location
            let end = (range.location + range.length)
            for i in start ..< end {
                if chars[i].isEditable {
                    chars[i].value = chars[i].format
                    if !chars[i].isClear {
                        chars[i].isClear = true
                        edited = true
                    }
                }
            }
            
            displayFormattedText()
            
            // Find next valid cursor position.
            if let location = findLocationBackward(fromLocation: range.location-1) {
                nextCursorPosition = location + 1
            }
            else {
                nextCursorPosition = findLocationForward(fromLocation: range.location) ?? range.location
            }
        }
        
        // Update new cursor position.
        moveCursorTo(nextCursorPosition)
        
        // Inform the delegate if the field is edited ( insert,replace,delete )
        if edited  {
            maskDelegate?.maskFieldDidChangeCharacter(self)
        }
    }
    
    fileprivate func moveCursorTo(_ position:Int) {
        if let newCursorPosition = self.position(from: self.beginningOfDocument, offset:position) {
            let newSelectedRange = self.textRange(from: newCursorPosition, to:newCursorPosition)
            self.selectedTextRange = newSelectedRange
        }
        previousCursorPosition = position
    }
    
    fileprivate func findLocationForward(fromLocation location:Int) -> Int? {
        var nextLocation:Int?
        for i in location ..< chars.count {
            if chars[i].isEditable {
                nextLocation = i
                break
            }
        }
        return nextLocation
    }
    
    fileprivate func findLocationBackward(fromLocation location:Int) -> Int? {
        var nextLocation:Int?
        for i in stride(from: location, to: -1, by: -1) {
            if chars[i].isEditable {
                nextLocation = i
                break
            }
        }
        return nextLocation
    }
    
}

//  MARK: - Display
extension KCMaskTextField {
    fileprivate func displayFormattedText() {
        // clear placeholder 
        placeholder = ""
        
        let myAttribute = [ NSAttributedString.Key.foregroundColor : UIColor.black ]
        let mString = NSMutableAttributedString(string: "", attributes: myAttribute )

        for (index,ch) in chars.enumerated() {
            var color  = UIColor.black
            if !ch.isEditable {
                color = delimiterColor
            }
            else if ch.isClear {
                color = formatColor
            }
            else {
                color = editableColor
            }
            var s = String(ch.value)
            
            // Update character case
            if ch.isEditable && !ch.isClear {
                let caseFormat:Character? = caseString.count == 1 ? caseString.first! : (index < caseString.count ? caseString[caseString.index(caseString.startIndex, offsetBy: index)] : nil)
                if let c = caseFormat {
                    switch c {
                    case "a":
                        s = s.lowercased()
                        chars[index].value = s.first!
                    case "A":
                        s = s.uppercased()
                        chars[index].value = s.first!
                    default:
                        break
                    }
                }
            }
            
            let aString = NSAttributedString(string: s, attributes: [NSAttributedString.Key.foregroundColor:color])
            mString.append(aString)
        }
        self.attributedText = mString
    }
}

//  MARK: - Validation

//     d	: Number, decimal number from 0 to 9
//     D	: Any symbol, except decimal number
//     a	: Alphabetic symbol, a-Z
//     A	: Not an alphabetic symbol
//     c    : Alphanumeric a-z,0-9
//     C    : Not an alphanumeric symbol
//     h	: Hexadecimal symbol
//     .	: Corresponds to any symbol (default)
//     *	: Non editable field
extension KCMaskTextField {
    fileprivate func isValidCharacter(_ character:Character, atIndex index:Int) -> Bool {
        let char = chars[index]
        let uni = String(character).unicodeScalars
        var isValidType = false
        switch char.type {
        case "d":
            isValidType = CharacterSet.decimalDigits.contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case "D":
            isValidType = !CharacterSet.decimalDigits.contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case "A":
            isValidType = !CharacterSet.letters.contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case "a":
            isValidType = CharacterSet.letters.contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case "c":
            isValidType = CharacterSet.alphanumerics.contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case "C":
            isValidType = !CharacterSet.alphanumerics.contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case "h":
            isValidType = CharacterSet(charactersIn: "0123456789abcdefABCDEF").contains(UnicodeScalar(uni[uni.startIndex].value)!)
            break
        case ".":
            isValidType = true
            break
        default:
            isValidType = false
            break
        }
        return isValidType
    }
}

//  MARK: - KCMaskFieldDelegate
protocol KCMaskFieldDelegate : class  {
    
    /// Tells the delegate that editing began for the specified mask field.
    func maskFieldDidBeginEditing(_ maskField: KCMaskTextField)
    
    /// Tells the delegate that editing finished for the specified mask field.
    func maskFieldDidEndEditing(_ maskField: KCMaskTextField)
    
    /// Tells the delegate that specified mask field change text.
    func maskFieldDidChangeCharacter(_ maskField: KCMaskTextField)
}

extension KCMaskFieldDelegate {

    func maskFieldDidBeginEditing(_ maskField: KCMaskTextField) {}
    
    func maskFieldDidEndEditing(_ maskField: KCMaskTextField) {}
    
    func maskFieldDidChangeCharacter(_ maskField: KCMaskTextField) {}
}
