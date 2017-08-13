//
//  DataService.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 28/06/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_BOX = DB_BASE.child("boxes")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CHANNELS = DB_BASE.child("channels")
//    private var _REF_ORDERS = 
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_BOX: DatabaseReference {
        return _REF_BOX
    }
    
//    var REF_ORDERS: DatabaseReference {
//        return _REF_ORDERS
//    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_CHANNELS: DatabaseReference {
        return _REF_CHANNELS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uID = KeychainWrapper.standard.string(forKey: "KEY_UID")
        let user = REF_USERS.child(uID!)
        
        return user
    }
    
    func createFirebaseDBUser(uID: String, userData: [Dictionary<String, String>]) {
        for value in userData {
            REF_USERS.child(uID).updateChildValues(value)
        }
    }
    
    func updateFirebaseDBUserGender(uID: String, gender: Dictionary<String, String>) {
        REF_USERS.child(uID).updateChildValues(gender)
    }
    
    func updateFirebaseDBBox(uID: String, boxID: Dictionary<String, String>) {
        REF_USERS.child(uID).updateChildValues(boxID)
    }
    
    func updateFirebaseDBPhone(uID: String, phoneNumber: Dictionary<String, String>) {
        REF_USERS.child(uID).updateChildValues(phoneNumber)
    }
}
