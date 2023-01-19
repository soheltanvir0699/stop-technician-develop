//
//  BXButton.swift
//  StopApp
//
//  Created by Agus Cahyono on 12/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

@IBDesignable open class BXButton: UIButton {
    
    // MAKR: - Border & Corners
    
    @IBInspectable open var cornerRaduis: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRaduis
            layer.masksToBounds = cornerRaduis > 0
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: - Actions
    
    override open var isSelected: Bool {
        didSet {
            self.setSelected(isSelected, animated: true)
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.setHighlighted(isHighlighted, animated: true)
        }
    }
    
    open func setSelected(_ selected: Bool, animated: Bool) {
        self.alpha = selected ? 0.8 : 1.0
    }
    
    open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.alpha = highlighted ? 0.7 : 1.0
    }
    
    // MARK: - Impact
    
    @IBInspectable open var isFeedbackEnabled: Bool = false
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
    
    open func generateImpact() {
        if isFeedbackEnabled {
            self.feedbackGenerator.impactOccurred()
        }
    }
    
    
    // MARK: - Shadows
    
    @IBInspectable open var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable open var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable open var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    private func setupShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRaduis).cgPath
        layer.masksToBounds = shadowRadius >= 0 ? false : true
    }
    
    // MARK: - Override
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupShadow()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }}
