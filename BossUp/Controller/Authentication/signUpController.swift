//
//  signUpController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress

class signUpController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!
    
    fileprivate var errorMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        ARSLineProgress.show()
        self.signUpUser {completed in
            if completed {
                NavigationManager.shared.yourShop()
            }else {
                print("No")
                self.showAlert(title: "Error", message: self.errorMessage)
            }
        }
    }
    
    fileprivate func signUpUser(completed: @escaping (_ success:Bool) -> Void) {
        
        if let email = self.email.text, let password = self.password.text , let rePassword = self.passwordRepeat.text {
            if password == rePassword {
                Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
                    if err != nil {
                        self.errorMessage = err?.localizedDescription ?? "Cannot define error"
                        completed(false)
                    } else {
                        if let user = user {
                            SharedInstance.userID = user.uid
                            let addUser = User(currentShop: "", email: user.email!, shop: nil)
                            CacheManager.shared.setDefaults(object: user.uid, forKey: "userID")
                            BackendManager.shared.createUser(user: addUser, userID: user.uid)
                            completed(true)
                        } else {
                            self.errorMessage = "Cannot find user"
                            completed(false)
                        }
                    } // if err != nil
                } // auth
            }else {
                self.errorMessage = "Passwords are not matched"
                completed(false)
            }
        }// if let
    }
}
