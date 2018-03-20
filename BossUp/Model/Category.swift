//
//  Category.swift
//  BossUp
//
//  Created by Trong Triet Le on 20/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

struct Category: Codable {
    
    let category1 = "Shoes"
    let category2 = "T–Shirt"
    let category3 = "Shirt"
    let category4 = "Pants"
    let category5 = "Bag"
    
    func toDict() -> [String:Any]? {
        var parameters: [String:Any] = [:]
        return parameters
    }
}
