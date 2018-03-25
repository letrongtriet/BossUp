//
//  UserShop.swift
//  BossUp
//
//  Created by Trong Triet Le on 20/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct UserShop: Codable {
    
    let shopName: String
    let type: String
    
    init(shopName: String, type: String) {
        self.shopName = shopName
        self.type = type
    }
    
    func toDict() -> [String:Any]? {
        var parameters: [String:Any] = [:]
        return parameters
    }
}
