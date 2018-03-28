//
//  signUpController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase

class signUpController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        //NavigationManager.shared.masterMenu()
        self.signUpUser {completed in
            if completed {
                print("Yes")
                NavigationManager.shared.masterMenu()
            }else {
                print("No")
            }
        }
    }
    
    fileprivate func signUpUser(completed: @escaping (_ success:Bool) -> Void) {
        
        if let email = self.email.text, let password = self.password.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "Cannot define error")
                    completed(false)
                } else {
                    if let user = user {
                        let addUser = User(currentShop: "", email: user.email!, shop: nil)
                        CacheManager.shared.setDefaults(object: user.uid, forKey: "userID")
                        BackendManager.shared.createUser(user: addUser, userID: user.uid)
                        completed(true)
                    } else {
                        print("Cannot find user")
                        completed(false)
                    }
                }
            }
        }
    }
}
