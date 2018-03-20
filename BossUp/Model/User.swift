//
//  User.swift
//  BossUp
//
//  Created by Trong Triet Le on 17/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let currentShop: String?
    let email: String
    let shop: [UserShop]?
    
    init(currentShop: String?, email: String, shop: [UserShop]?) {
        self.currentShop = currentShop
        self.email = email
        self.shop = shop
    }
    
    func toDict() -> [String:Any]? {
        var parameters: [String:Any] = [:]
        
        parameters["currentShop"] = self.currentShop
        parameters["email"] = self.email
        parameters["shop"] = self.shop
        
        return parameters
    }
}
