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
        
        parameters["category1"] = category1
        parameters["category2"] = category2
        parameters["category3"] = category3
        parameters["category4"] = category4
        parameters["category5"] = category5
        
        return parameters
    }
}
