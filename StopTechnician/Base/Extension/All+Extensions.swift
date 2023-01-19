//
//  UITextField+Extensions.swift
//  StopApp
//
//  Created by Agus Cahyono on 14/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

extension UITextField {
    
    // trim space from textfield and return value
    func trim() -> String {
        let string = self.text ?? ""
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIButton {
    
    // trim space from textfield and return value
    func trim() -> String {
        let string = self.titleLabel?.text ?? ""
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UILabel {
    
    // trim space from textfield and return value
    func trim() -> String {
        let string = self.text ?? ""
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    
    func replaceDashUnderScore() -> String {
        let replace = self.replacingOccurrences(of: "_", with: " ")
        return replace
    }
    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "CircularStd-Medium", size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "CircularStd-Book", size: 14)!]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        
        return self
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}


extension Double {
    
    var getKiloMeters: String {
        return "Within " + String(format: "%.1f", self) + " KM"
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
