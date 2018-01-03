//
//  TabBar.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 04/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBar {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.frame = bounds
        frost.autoresizingMask = .flexibleWidth
        insertSubview(frost, at: 0)
    }
}
