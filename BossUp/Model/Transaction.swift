//
//  Transaction.swift
//  BossUp
//
//  Created by Trong Triet Le on 20/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    
    let capital: String
    let moneyGet: String
    let productId: String
    let productName: String
    let quantity: String
    let sellerEmail: String
    let sellerId: String
    let time: String
    
    init(capital: String, moneyGet: String, productId: String, productName: String, quantity: String, sellerEmail: String, sellerId: String, time: String){
        self.capital = capital
        self.moneyGet = moneyGet
        self.productId = productId
        self.productName = productName
        self.quantity = quantity
        self.sellerEmail = sellerEmail
        self.sellerId = sellerId
        self.time = time
    }
    
    func toDict() -> [String:Any]? {
        var parameters: [String:Any] = [:]
        return parameters
    }
    
}
