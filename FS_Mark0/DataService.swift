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
    private var _REF_SAMPLES = DB_BASE.child("samples")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CHANNELS = DB_BASE.child("channels")
    private var _REF_COUPONS = DB_BASE.child("coupons")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_SAMPLES: DatabaseReference {
        return _REF_SAMPLES
    }
    
    var REF_COUPONS: DatabaseReference {
        return _REF_COUPONS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_CHANNELS: DatabaseReference {
        return _REF_CHANNELS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uID = Auth.auth().currentUser?.uid
        let user = REF_USERS.child(uID!)
        
        return user
    }
    
    func createFirebaseUserWithUID(uID: String, userData: [Dictionary<String, String>]) {
        for value in userData {
            REF_USERS.child(uID).updateChildValues(value)
        }
    }
    
    func updateFirebaseDBUserWithUserData(userData: [Dictionary<String, AnyObject>]) {
        for value in userData {
            REF_USER_CURRENT.updateChildValues(value)
        }
    }
    
    func updateFirebaseDBUserWithQR(userData: [Dictionary<String, AnyObject>]) {
        for value in userData {
            REF_USER_CURRENT.child("samples").updateChildValues(value)
        }
    }
    
    func updateFirebaseDBSampleQR(userData: [Dictionary<String, AnyObject>]) {
        for value in userData {
            REF_SAMPLES.updateChildValues(value)
        }
    }
    
    func checkForDuplicateScanInSamplesDB(qrCode: String) {
        REF_SAMPLES.observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? NSDictionary {
//                    print(dict)
                    print(qrCode)
                    if let newDict = dict[qrCode] as? [String: AnyObject] {
                        print(newDict)
                    } else {
                        print("Error: Can't")
                    }
                }
            }) { (error) in
                print("Error: \(error.localizedDescription)")
        }
    }
    
}
