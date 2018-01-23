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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var copyView: UIView!
    
    var coupon: Coupon!
    var redirectURL: String!
    
    func configureCell(coupon: Coupon) {
        self.coupon = coupon
        titleLabel.text = coupon.title
        subtitleLabel.text = coupon.subtitle
        img.downloadedFrom(link: coupon.imgURL!)
        if coupon.showCouponOnScreen != nil {
            couponLabel.isHidden = false
            couponLabel.text = "Coupon  Code: \(coupon.showCouponOnScreen!)"
        } else {
            couponLabel.isHidden = false
            couponLabel.text = "Click here to get your coupon"
        }
//        redirectURL = coupon.redirectURL
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showCopyView() {
        UIView.transition(with: self.copyView, duration: 0.2, options: .transitionFlipFromBottom, animations: {
            self.copyView.isHidden = false

        }) { (flag) in
            if flag {

                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                    UIView.transition(with: self.copyView, duration: 0.2, options: .transitionFlipFromTop, animations: {
                        self.copyView.isHidden = true
                    }, completion: nil)
//                    self.copyView.isHidden = true
                })
            }
        }
    }
}
