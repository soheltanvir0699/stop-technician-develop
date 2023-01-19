//
//  AppDelegate.swift
//  StopTechician
//
//  Created by Agus Cahyono on 06/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver {

    var window: UIWindow?

    var environment: APIEnvironment = .production
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        APIEnvironment.environment = environment
        BaseDelegate.build()
        UserToken.cachedProfile()
        
        let freshInstall = !UserDefaults.standard.bool(forKey: "stopTechnicianInstalled")
        if freshInstall {
            UserToken.deleteProfile()
            UserToken.deleteToken()
            UserDefaults.standard.set(true, forKey: "stopTechnicianInstalled")
        }
        
        let notificationReceiveBlock: OSHandleNotificationReceivedBlock = { notification in
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            let payload = result?.notification.payload
            
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            if let additionalData = result?.notification.payload.additionalData {
                print("Additional Data = \(additionalData)")
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                     self.openDetailOrder()
                }
                
                if let actionID = result?.action.actionID {
                    print("ID \(actionID)")
                    self.openDetailOrder()
                }
                
            }
            
        }
        
        let oneSignalItinSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, kOSSettingsKeyInAppAlerts: true]
        OneSignal.initWithLaunchOptions(
            launchOptions,
            appId: "9a7bd816-1276-4a8d-8866-101c2d046800",
            handleNotificationReceived: notificationReceiveBlock,
            handleNotificationAction: notificationOpenedBlock,
            settings:   oneSignalItinSettings)
        OneSignal.inFocusDisplayType = .notification
        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)

        return true
        
    }
    
    func openDetailOrder() {
        
        let storyboard = UIStoryboard.init(name: "LoginView", bundle: nil)
        let rootVC: SplashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        UIApplication.shared.keyWindow?.rootViewController = rootVC
        
        NotificationCenter.default.post(name: NSNotification.Name.init("openmyorder"), object: nil)
        BaseDelegate.isReceivedNotification = true
    }
    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        print("Permission Push Notification: \(String(describing: stateChanges))")
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        print("Subscription OneSignal: \(String(describing: stateChanges))")
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}


}

