//
//  Order.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 12/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
class Order: Decodable{
    var addressLine1: String?
    var addressLine2: String?
    var city: String?
    var pincode: String?
    var state: String?
    var name: String?
    var uid: String?
    var date: String?
    var orderID: String?
}
