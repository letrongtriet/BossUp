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
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var settingImage: UIImageView!
    
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
        dismiss(animated: false) {
            NavigationManager.shared.yourShop()
        }
    }
    
    @objc fileprivate func reportPressed() {
        dismiss(animated: false) {
            NavigationManager.shared.report()
        }    }
    
    @objc fileprivate func profilePressed() {
        dismiss(animated: false) {
            NavigationManager.shared.profile()
        }    }
    
    @objc fileprivate func settingsPressed() {
        dismiss(animated: false) {
            NavigationManager.shared.settings()
        }    }
    
    fileprivate func setupUI() {
        switch masterMenuState {
        case "shop":
            self.shopLabel.textColor = .black
            self.shopImage.image = #imageLiteral(resourceName: "ic_shop_active_black")
        case "report":
            self.reportLabel.textColor = .black
            self.reportImage.image = #imageLiteral(resourceName: "ic_activity_active_black")
        case "profile":
            self.profileLabel.textColor = .black
            self.profileImage.image = #imageLiteral(resourceName: "ic_profile_active_black")
        case "settings":
            self.settingsLabel.textColor = .black
            self.settingImage.image = #imageLiteral(resourceName: "ic_settings_active_black")
        default:
            self.shopLabel.textColor = .black
            self.shopImage.image = #imageLiteral(resourceName: "ic_shop_active_black")
        }
    }
}
