//
//  noProductVC.swift
//  BossUp
//
//  Created by Trong Triet Le on 07/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import DeviceKit

class noProductVC: UIViewController {
    @IBOutlet weak var upperArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("No Product VC")
        
        print(Device().description)
        
        if Device().description.range(of: "iPhone SE") != nil {
            upperArrow.setWidth(width: 40)
            upperArrow.setHeight(height: 60)
            
            downArrow.setWidth(width: 40)
            downArrow.setHeight(height: 60)
        }
    }

}
