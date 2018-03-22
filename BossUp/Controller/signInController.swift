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
                    print(err)
                }else {
                    NavigationManager.shared.masterMenu()
                }
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        NavigationManager.shared.signUp()
    }
}

