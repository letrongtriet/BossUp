//
//  CacheManager.swift
//  BossUp
//
//  Created by Trong Triet Le on 20/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation

class Cache {
    
    static let shared: Cache = Cache()
    
    private init() {}
    
    // store the user token for later use
    let userDefaults = UserDefaults.standard
    
    func setDefaults(object: Any, forKey: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(data, forKey: forKey)
    }
    
    func object(forKey: String) -> Any? {
        if let data = userDefaults.object(forKey: forKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) ?? nil
        }
        return nil
    }
    
    func removeObject(forKey: String) {
        userDefaults.removeObject(forKey: forKey)
    }
    
}
