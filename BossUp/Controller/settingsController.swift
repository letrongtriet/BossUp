//
//  settingsController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import SwiftyJSON

class settingsController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    let currencyData = NSData(contentsOfFile: Bundle.main.path(forResource: "Common-Currency", ofType: "json")!)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Do the actual JSON parsing
        do {
            let json = try JSON(data: currencyData! as Data)
            print(json)
        } catch {
            // Do nothing for now
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.gray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
    }
    
    fileprivate func currencyPicker() {
        
    }

}
