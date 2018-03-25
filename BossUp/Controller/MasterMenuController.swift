//
//  MasterMenuController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class MasterMenuController: UIViewController {
    
    @IBOutlet weak var yourShop: UIStackView!
    @IBOutlet weak var report: UIStackView!
    @IBOutlet weak var profile: UIStackView!
    @IBOutlet weak var settings: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTappedUI()
    }
    
    fileprivate func setUpTappedUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MasterMenuController.yourShopPressed))
        yourShop.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(MasterMenuController.reportPressed))
        report.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(MasterMenuController.profilePressed))
        profile.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(MasterMenuController.settingsPressed))
        settings.addGestureRecognizer(tap4)
    }
    
    @objc fileprivate func yourShopPressed() {
        NavigationManager.shared.yourShop()
    }
    
    @objc fileprivate func reportPressed() {
        NavigationManager.shared.report()
    }
    
    @objc fileprivate func profilePressed() {
        NavigationManager.shared.profile()
    }
    
    @objc fileprivate func settingsPressed() {
        NavigationManager.shared.settings()
    }

}
