//
//  AppDelegate.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import DropDown
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.sharedManager().enable = true
        
        self.checkUser()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
}

extension AppDelegate {
    func checkUser() {
        if let user = Auth.auth().currentUser {
            if CacheManager.shared.object(forKey: "userID") != nil {
                let userID = String(describing: CacheManager.shared.object(forKey: "userID")!)
                if userID == user.uid {
                    SharedInstance.userID = user.uid
                    SharedInstance.userEmail = user.email!
                    NavigationManager.shared.yourShop()
                }
            }
        }
    }
}

