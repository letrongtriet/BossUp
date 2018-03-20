//
//  NavigationManager.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

public let window = AppDelegate.shared.window

public class NavigationManager {
    
    private init() {}
    
    static let shared : NavigationManager = NavigationManager()
    
    func signUp() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "signUpController") as! signUpController
        
        vc.view.frame = UIScreen.main.bounds
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = vc
        }, completion: nil)
    }
    
    func masterMenu() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MasterMenuController") as! MasterMenuController
        
        vc.view.frame = UIScreen.main.bounds
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = vc
        }, completion: nil)
    }
    
    func yourShop() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "yourShopController") as! yourShopController
        
        vc.view.frame = UIScreen.main.bounds
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = vc
        }, completion: nil)
    }
    
    func report() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "reportController") as! reportController
        
        vc.view.frame = UIScreen.main.bounds
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = vc
        }, completion: nil)
    }
    
    func profile() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "profileController") as! profileController
        
        vc.view.frame = UIScreen.main.bounds
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = vc
        }, completion: nil)
    }
    
    func settings() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "settingsController") as! settingsController
        
        vc.view.frame = UIScreen.main.bounds
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = vc
        }, completion: nil)
    }
    
}
