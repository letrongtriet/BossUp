//
//  noShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import ARSLineProgress

class noShopVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("noShopVC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ARSLineProgress.shown == true {
            ARSLineProgress.hide()
        }
    }
}
