//
//  Shop.swift
//  BossUp
//
//  Created by Trong Triet Le on 17/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct Shop: Codable {
    
    let category: Category
    let currentCurrencyCode: String
    let member: [String]
    let name: String
    let product: [Product]?
    let transaction: [Transaction]?
    
    init(category: Category, currentCurrencyCode: String, member: [String], name: String, product: [Product]?, transaction: [Transaction]?) {
        self.category = category
        self.currentCurrencyCode = currentCurrencyCode
        self.member = member
        self.name = name
        self.product = product
        self.transaction = transaction
    }
    
    func toDict() -> [String:Any]? {
        var parameters: [String:Any] = [:]
        
        parameters["category"] = category
        parameters["currentCurrencyCode"] = currentCurrencyCode
        parameters["member"] = member
        parameters["name"] = name
        parameters["transaction"] = transaction
        
        return parameters
    }
}
