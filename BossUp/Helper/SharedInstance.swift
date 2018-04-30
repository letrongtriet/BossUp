//
//  SharedInstance.swift
//  BossUp
//
//  Created by Trong Triet Le on 07/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import SwiftyJSON

public struct SharedInstance {
    static var userID: String = ""
    
    static var userEmail: String = ""
    
    static var currentShopName: String = ""
    
    static var shopID: String = ""
    
    static var currentCurrencyCode = "USD"
    
    static var addMember = ""
    
    static var productList:[String] = []
    
    static var priceList = [String]()
    static var nameList = [String]()
    
    static var chosenProduct = ""
    static var chosenProductName = ""
    static var chosenProductPrice = ""
    static var choseProductCapital = ""
    static var chosenProductImage = UIImage()
    static var chosenProductEdit = ""
    
    static var isOwner:Bool = false
    static var currentShopStaffs = [String:String]()
    
    static var filterOption = ""
    static var transactionFilter = "30 days"
}
