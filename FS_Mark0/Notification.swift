//
//  Notification.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 05/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

class MyClass {
    enum Notifications: String, NotificationName {
        case myNotification
    }
}
