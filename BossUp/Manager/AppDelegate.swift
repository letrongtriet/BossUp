//
//  AppDelegate.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        if let user = Auth.auth().currentUser {
            print("from auth : \(user.uid)")
            let cache = CacheManager.shared.object(forKey: "userID")
            print(cache)
            if CacheManager.shared.object(forKey: "userID") != nil {
                let userID = String(describing: CacheManager.shared.object(forKey: "userID")!)
                print("from cache: \(userID)")
                if userID == user.uid {
                    NavigationManager.shared.yourShop()
                }
            }
        }
        
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


}

