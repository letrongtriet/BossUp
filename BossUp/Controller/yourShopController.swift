//
//  yourShopController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import DropDown

class yourShopController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var shopButton: UIButton!
    
    let defaultList = ["Create a shop","Find a shop"]
    
    var shopList = ["Admin's Shop"]
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setShadow()
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressedShopButton(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.gray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
    }
    
    fileprivate func setupButton() {
        
        dropDown.anchorView = self.shopButton
        dropDown.bottomOffset = CGPoint(x: 0, y: shopButton.bounds.height)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cornerRadius = 10
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            BackendManager.shared.userReference.child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let value = snapshot.value else {return}
                
                guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
                print(data)
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {return}
                print(user)
                
                if user.currentShop == "" {
                    self.dropDown.dataSource = self.defaultList
                    self.shopButton.setTitle("Create a Shop", for: .normal)
                }else {
                    print("Found a list")
                    self.shopButton.setTitle("Admin's Shop", for: .normal)
                    self.dropDown.dataSource = self.shopList
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.shopButton.setTitle(item, for: .normal)
        }

    }
}



