//
//  createShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class createShopVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("createShopVC")
    }
    
    @IBAction func didPressCreateButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("shopCreated"), object: nil)
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("shopCanceled"), object: nil)
    }
    

}
