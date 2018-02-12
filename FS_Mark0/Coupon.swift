//
//  Coupon.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 20/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
class Coupon: Decodable{
    var brandName: String
    var imgURL: String
    var subtitle: String
    var title: String
    var couponID: String
    var redeem: String?
}
