
//
//  Product.swift
//  BossUp
//
//  Created by Triet Le on 06/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct Product: Codable {
    let capital: String
    let category: String
    let name: String
    let price: String
    let quantity: Quantity
    let sizeType: String
    
    init(capital:String, category:String, name:String, price:String, quantity:Quantity, sizeType:String) {
        self.capital = capital
        self.category = category
        self.name = name
        self.price = price
        self.quantity = quantity
        self.sizeType = sizeType
    }
}
