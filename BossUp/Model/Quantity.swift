//
//  Quantity.swift
//  BossUp
//
//  Created by Triet Le on 06/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct Quantity: Codable {
    let quantity:String
    let size:String
    
    init(quantity:String, size:String) {
        self.quantity = quantity
        self.size = size
    }
}
