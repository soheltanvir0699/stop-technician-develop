//
//  StopAppBaseView.swift
//  StopApp Technician
//
//  Created by Agus Cahyono on 19/07/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import ViewAnimator
import XLPagerTabStrip
import ObjectiveC
import OneSignal

class StopAppBaseView: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MKProgress.config.hudType = .radial
        MKProgress.config.circleBorderColor = UIColor.hexStringToUIColor(hex: "#E42F38")
        MKProgress.config.hudColor = .clear
        MKProgress.config.width = 80
        MKProgress.config.height = 80
        MKProgress.config.circleRadius = 20
        MKProgress.config.circleBorderWidth = 5
        
    }
    
    func showLoading() {
        MKProgress.show()
    }
    
    func dismissLoading() {
        MKProgress.hide(true)
    }
    
    static func logoutApp() {
        
        UserToken.deleteProfile()
        UserToken.deleteToken()
        
        OneSignal.setSubscription(false)
        OneSignal.deleteTag(Profile.shared?.phone ?? "")
        
        let storyboard = UIStoryboard.init(name: "LoginView", bundle: nil)
        let rootVC: LoginView = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginView
        let embedNav = UINavigationController(rootViewController: rootVC)
        
        UIApplication.shared.keyWindow?.rootViewController = embedNav
    }
    
    func hideKeyboardWhenTappedAround(_ bool: Bool = true) {
        if bool {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func alertMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            default:
                break
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNavigationBar(_ title: String, color: String, titleColor: String = "7D8B97") {
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: color)
        self.navigationController?.navigationBar.isTranslucent = false
         self.navigationController?.navigationBar.isHidden = false
        
        self.title = title
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: titleColor),
            NSAttributedString.Key.font:  UIFont(name: "CircularStd-Bold", size: 30) ?? UIFont.boldSystemFont(ofSize: 30)
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: titleColor),
            NSAttributedString.Key.font:  UIFont(name: "CircularStd-Book", size: 18.0) ?? UIFont.systemFont(ofSize: 18)
        ]
    }
    
    func transparentBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setArrowBack(imageArrow: UIImage) {
        let btn1 = UIButton(type: .custom)
        
        if GusLanguage.shared.currentLang == "ar" {
           btn1.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            btn1.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        
        btn1.setImage(imageArrow, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.popviewController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item1
        self.navigationItem.leftBarButtonItem?.tintColor = .red
        
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func popviewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func setupDirectionAnimation(_ direction: Direction) {
        let animation = AnimationType.from(direction: direction, offset: 50.0)
        view.animate(animations: [animation])
    }
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
    func setInternetErrorState(_ table: SDStateTableView, completion: @escaping() -> ()) {
        table.setState(
            .withButton(
                errorImage: "serverError",
                title: "Whoops !",
                message: "We’re having difficulty connecting to the server. Check your connection or try again later.",
                buttonTitle: "RETRY",
                buttonConfig: { (button) in
                    button.backgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
                    button.setTitleColor(.white, for: .normal)
            },
                retryAction: {
                    DispatchQueue.main.async {
                        completion()
                    }
            }))
    }
    
    func setServerErrorState(_ table: SDStateTableView, completion: @escaping() -> ()) {
        table.setState(
            .withButton(
                errorImage: "serverError",
                title: "Whoops !",
                message: "We’re having difficulty connecting to the server. Check your connection or try again later.",
                buttonTitle: "RETRY",
                buttonConfig: { (button) in
                    button.backgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
                    button.setTitleColor(.white, for: .normal)
            },
                retryAction: {
                    DispatchQueue.main.async {
                        completion()
                    }
            }))
    }
    

}

extension UIImage {
    
    func flipImageLeftRight(_ image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIViewController {
    
    public func alertMessage(_ title: String, message: String, completion: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                completion()
            case .cancel:break
            case .destructive:break
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func confirmationMessage(_ title: String, message: String, didOK: @escaping () -> ()) {
        
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: GusSetLanguage.getLanguage(key: "global.string.yes"), style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            didOK()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: GusSetLanguage.getLanguage(key: "global.string.no"), style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    
}

extension ButtonBarPagerTabStripViewController {
    
    func setNavigationBar(_ title: String, color: String, titleColor: String = "7D8B97") {
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: color)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        
        self.title = title
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: titleColor),
            NSAttributedString.Key.font:  UIFont(name: "CircularStd-Bold", size: 30) ?? UIFont.boldSystemFont(ofSize: 30)
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: titleColor),
            NSAttributedString.Key.font:  UIFont(name: "CircularStd-Book", size: 18.0) ?? UIFont.systemFont(ofSize: 18)
        ]
    }
    
}

extension UINavigationController {
    
    func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

    }
    
    func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
}

struct AuthInputStyle: AnimatedTextInputStyle {
    let placeholderInactiveColor = UIColor.hexStringToUIColor(hex: "7D8B97")
    let activeColor =  UIColor.hexStringToUIColor(hex: "7D8B97")
    let inactiveColor = UIColor.hexStringToUIColor(hex: "4A4A4A")
    let lineInactiveColor = UIColor.hexStringToUIColor(hex: "EDF0F2")
    let lineActiveColor = UIColor.hexStringToUIColor(hex: "EDF0F2")
    let lineHeight: CGFloat = 1
    let errorColor = UIColor.hexStringToUIColor(hex: "C80001")
    let textInputFont = UIFont.init(name: "CircularStd-Book", size: 14.0)!
    let textInputFontColor = UIColor.hexStringToUIColor(hex: "4A4A4A")
    let placeholderMinFontSize: CGFloat = 10
    let counterLabelFont: UIFont? = UIFont.init(name: "CircularStd-Book", size: 9.0)
    let leftMargin: CGFloat = 10
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 10
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = -5
    let yPlaceholderPositionOffset: CGFloat = -5
    public let textAttributes: [String: Any]? = nil
}


private var originalButtonText: String?
private var activityIndicator: UIActivityIndicatorView!

extension UIButton{
    
    func showSpinner() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideSpinner() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }
    
    func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
