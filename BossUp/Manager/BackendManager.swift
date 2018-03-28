//
//  BackendManager.swift
//  BossUp
//
//  Created by Trong Triet Le on 18/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import Foundation
import Firebase

class BackendManager {
    
    static let shared: BackendManager = BackendManager()
    
    private init() {}
    
    let userReference = Database.database().reference().child(DataPath.Users)
    let shopReference = Database.database().reference().child(DataPath.Shops)
    let imageReference = Storage.storage().reference().child(DataPath.image)
    
    func createUser(user: User, userID: String){
        BackendManager.shared.userReference.child(userID).setValue(user.toDict())
    }
    
    func updateUser(user: User, userID: String) {
        if let json = user.toDict() {
            BackendManager.shared.userReference.child(userID).updateChildValues(json)
        }else {
            print("Cannot update user profile")
        }
    }
    
}
