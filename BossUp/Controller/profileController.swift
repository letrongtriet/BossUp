//
//  profileController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase

class profileController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var profile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setShadow()
    }
    
    @IBAction func didPressMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressSignOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            NavigationManager.shared.signIn()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.gray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
    }
    
    fileprivate func updateProfile() {
        let user = Auth.auth().currentUser
        
        if user != nil {
            if let userEmail = user?.email {
                self.profile.text = userEmail
            }
        }
    }
}
