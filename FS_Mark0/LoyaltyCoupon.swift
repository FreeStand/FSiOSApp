//
//  LoyaltyCoupon.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 16/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation

class LoyaltyCoupon: Decodable {
    var imgURL: String?
    var subtitle: String?
    var title: String?
    var couponID: String?
    var redeem: Bool?
    var unlockable: Bool?
    var lockScreenText: String?
}
