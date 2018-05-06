//
//  ViewController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress

class signInController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        ARSLineProgress.showWithPresentCompetionBlock {
            if let userName = self.email.text, let userPassword = self.password.text {
                Auth.auth().signIn(withEmail: userName, password: userPassword) { (user, err) in
                    if err != nil {
                        let message = err?.localizedDescription ?? "Error to be defined"
                        ARSLineProgress.hideWithCompletionBlock {
                            self.showAlert(title: "Error", message: message)
                        }
                    }else {
                        if let user = user {
                            SharedInstance.userID = user.uid
                            CacheManager.shared.setDefaults(object: user.uid, forKey: "userID")
                            NavigationManager.shared.yourShop()
                        } else {
                            ARSLineProgress.hideWithCompletionBlock {
                                self.showAlert(title: "Error", message: "Cannot find user")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        NavigationManager.shared.signUp()
    }
}

