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
    @IBOutlet weak var getCouponLabel: UILabel!
    @IBOutlet weak var copyView: UIView!
    @IBOutlet weak var shadowView: UIView!

    
    var coupon: Coupon!
    var redirectURL: String!
    
    func configureCell(coupon: Coupon) {
        self.coupon = coupon
        titleLabel.text = coupon.title
        subtitleLabel.text = coupon.subtitle
        img.downloadedFrom(link: coupon.imgURL)
        if coupon.redeem != nil {
            couponLabel.isHidden = false
            getCouponLabel.text = "Coupon Code"
            couponLabel.text = coupon.redeem
        } else {
            couponLabel.isHidden = true
            getCouponLabel.text = "Click here to get your coupon"
        }
        
        self.shadowView.layer.cornerRadius = 2.0
        self.shadowView.layer.borderWidth = 1.0
        self.shadowView.layer.borderColor = UIColor.clear.cgColor
        self.shadowView.layer.masksToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize.zero
        self.shadowView.layer.shadowRadius = 1.0
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowPath = UIBezierPath(rect: self.shadowView.bounds).cgPath
        self.shadowView.layer.shouldRasterize = true
        
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
