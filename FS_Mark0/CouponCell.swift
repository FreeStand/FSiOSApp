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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var coupon: Coupon!
    var redirectURL: String!
    
    func configureCell(coupon: Coupon) {
        self.coupon = coupon
        titleLabel.text = coupon.title
        subtitleLabel.text = coupon.subtitle
        redirectURL = coupon.redirectURL
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        redeemBtn.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        print("info")
        NotificationCenter.default.post(name: Notifications.myNotification.name, object: nil)
    }
    
}
