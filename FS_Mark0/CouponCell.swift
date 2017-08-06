//
//  CouponCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 04/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {
    
    enum Notifications: String, NotificationName {
        case myNotification
    }

    @IBOutlet weak var redeemBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        redeemBtn.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func redeemBtnPressed(_ sender: Any) {
        print("redeem")
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        print("info")
        NotificationCenter.default.post(name: Notifications.myNotification.name, object: nil)
    }
    
}