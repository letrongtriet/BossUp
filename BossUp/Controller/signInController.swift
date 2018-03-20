//
//  ViewController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class signInController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let userName = self.email.text
        let userPassword = self.password.text
        
        
        
        NavigationManager.shared.masterMenu()
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        NavigationManager.shared.signUp()
    }
}

