//
//  createShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase

class createShopVC: UIViewController {
    
    fileprivate let userRef = BackendManager.shared.userReference
    fileprivate let shopRef = BackendManager.shared.shopReference
    
    @IBOutlet weak var shopName: UITextField!
    
    let email = Auth.auth().currentUser!.email!
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didPressCreateButton(_ sender: UIButton) {
        
        if self.shopName.text?.isEmpty == false {
            let shopNameText = self.shopName.text!
            let key = shopRef.childByAutoId().key

            let parameter:[String:Any] = ["name":shopNameText,
                                          "category":Category().toDict()!,
                                          "currentCurrencyCode":Share.currentCurrencyCode,
                                          "member":[self.uid:["owner":email]]]
            
            userRef.child(self.uid).child("currentShop").setValue(key)
            shopRef.child(key).updateChildValues(parameter)
            
            userRef.child(uid).child("shop").updateChildValues([key:["shopName":shopNameText,"type":"owner"]])
            
            Share.shopID = key
            Share.currentShopName = shopNameText

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("addShop"), object: nil)
            }
        }else {
            self.showAlert(title: "Error", message: "Please enter name of your new shop")
        }
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("addShop"), object: nil)
        }
    }
}
