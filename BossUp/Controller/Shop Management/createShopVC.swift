//
//  createShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class createShopVC: UIViewController {
    
    @IBOutlet weak var shopName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("createShopVC")
    }
    
    @IBAction func didPressCreateButton(_ sender: UIButton) {
        
        if self.shopName.text?.isEmpty == false {
            let nameOfShop = self.shopName.text
            
            BackendManager.shared.userReference.child(SharedInstance.userID).child("currentShop").setValue(nameOfShop)
            
            let currentShopKey = BackendManager.shared.shopReference.childByAutoId().key
            let category = Category().toDict()
            
            BackendManager.shared.shopReference.child(currentShopKey).updateChildValues(["name":nameOfShop!,"category":category!,"currentCurrencyCode":SharedInstance.currentCurrencyCode,"member":[SharedInstance.userID:["owner":SharedInstance.userEmail]]])
            
            BackendManager.shared.userReference.child(SharedInstance.userID).child("shop").updateChildValues([currentShopKey:["shopName":nameOfShop,"type":"owner"]])
            
            SharedInstance.shopID = currentShopKey
            SharedInstance.currentShopName = nameOfShop!
            
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
