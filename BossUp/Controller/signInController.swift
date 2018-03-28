//
//  ViewController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase

class signInController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if let userName = self.email.text, let userPassword = self.password.text {
            Auth.auth().signIn(withEmail: userName, password: userPassword) { (user, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "Error to be defined")
                }else {
                    if let user = user {
                        CacheManager.shared.setDefaults(object: user.uid, forKey: "userID")
                    } else {
                        print("Cannot find user")
                    }
                    NavigationManager.shared.masterMenu()
                }
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        NavigationManager.shared.signUp()
    }
}

