//
//  MasterMenuController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

var masterMenuState: String = "shop"

class MasterMenuController: UIViewController {
    
    @IBOutlet weak var yourShop: UIStackView!
    @IBOutlet weak var report: UIStackView!
    @IBOutlet weak var profile: UIStackView!
    @IBOutlet weak var settings: UIStackView!
    
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTappedUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
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
    
    fileprivate func setupUI() {
        switch masterMenuState {
        case "shop":
            self.shopLabel.textColor = .black
        case "report":
            self.reportLabel.textColor = .black
        case "profile":
            self.profileLabel.textColor = .black
        case "settings":
            self.settingsLabel.textColor = .black
        default:
            self.shopLabel.textColor = .black
        }
    }
}
