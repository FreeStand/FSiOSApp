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
    private var _phone: String!
    var name: String {
        return (Auth.auth().currentUser?.displayName)!
    }
    var email: String {
        return (Auth.auth().currentUser?.email)!
    }
    var uid: String {
        return (Auth.auth().currentUser?.uid)!
    }
       
}

