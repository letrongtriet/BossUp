//
//  noProductVC.swift
//  BossUp
//
//  Created by Trong Triet Le on 07/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import DeviceKit
import ARSLineProgress

class noProductVC: UIViewController {
    @IBOutlet weak var upperArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("No Product VC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ARSLineProgress.shown == true {
            ARSLineProgress.hide()
        }
    }
}
