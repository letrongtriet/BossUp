//
//  yourShopController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase

class yourShopController: UIViewController {
    
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var menuBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            BackendManager.shared.userReference.child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let value = snapshot.value else {return}
                
                guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
                print(data)
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {return}
                
                if user.currentShop == "" {
                    self.setButton()
                }else {
                    
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    fileprivate func setButton() {
        
    }

}
