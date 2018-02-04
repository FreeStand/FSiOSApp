//
//  NSLayoutConstraint+multiplier.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 04/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
