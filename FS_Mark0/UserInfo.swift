//
//  UserInfo.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 12/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserInfo {
    
    static let ui = UserInfo()
    public static var uid = Auth.auth().currentUser?.uid
    public static var gender = UserDefaults.standard.string(forKey: "userGender")
    
    private var _NAME = Auth.auth().currentUser?.displayName ?? "John Doe"
    private var _EMAIL = Auth.auth().currentUser?.email ?? "email@example.com"
    private var _PHONE = Auth.auth().currentUser?.phoneNumber ?? "9876543210"
    private var _GENDER = UserDefaults.standard.string(forKey: "userGender") ?? "Unknown"
    private var _DOB = UserDefaults.standard.string(forKey: "userDob") ?? "Below 18"
    private var _ISGOOGLESIGNEDIN = UserDefaults.standard.string(forKey: "isGoogleSignedIn") ?? "false"
    
    var isGoogleSignedIn: String {
        return _ISGOOGLESIGNEDIN
    }

    var name: String {
        return _NAME
    }
    
    var email: String {
        return _EMAIL
    }
    
    var phoneNo: String {
        return _PHONE
    }
    
    var dob: String {
        return _DOB
    }
    
    var gender: String{
        return _GENDER
    }
    
}

