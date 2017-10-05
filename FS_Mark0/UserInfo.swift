//
//  UserInfo.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 12/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserInfo {
    
    static let ui = UserInfo()
    
    private var _NAME = Auth.auth().currentUser?.displayName ?? "John Doe"
    private var _EMAIL = Auth.auth().currentUser?.email ?? "email@example.com"
    private var _PHONE = Auth.auth().currentUser?.phoneNumber ?? "9876543210"
    private var _GENDER = UserDefaults.standard.string(forKey: "userGender") ?? "Unknown"
    private var _DOB = UserDefaults.standard.string(forKey: "userDob") ?? "Below 18"


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

