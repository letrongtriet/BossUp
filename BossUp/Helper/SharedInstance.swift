//
//  SharedInstance.swift
//  BossUp
//
//  Created by Trong Triet Le on 07/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

public struct SharedInstance {
    static var userID: String = ""
    
    static var userEmail: String = ""
    
    static var currentShopName: String = ""
    
    static var shopID: String = ""
    
    static var currentCurrencyCode: String = "USD"
    
    static var addMember = ""
    
    static var productList:[String] = []
    
    static var priceList = [String]()
    static var nameList = [String]()
    
    static var chosenProduct = ""
    static var chosenProductName = ""
    static var chosenProductPrice = ""
    static var chosenProductImage = UIImage()
}
