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
    
    private var _NAME = Auth.auth().currentUser?.displayName ?? "Aryan"
    private var _EMAIL = Auth.auth().currentUser?.email ?? "email"
    private var _PHONE = Auth.auth().currentUser?.phoneNumber ?? "9876543210"
    
    var name: String {
        return _NAME
    }
    
    var email: String {
        return _EMAIL
    }
    
    var phoneNo: String {
        return _PHONE
    }
    
}

