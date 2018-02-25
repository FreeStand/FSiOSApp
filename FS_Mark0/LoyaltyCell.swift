//
//  LoyaltyCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 16/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class LoyaltyCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lockScreenView: UIView!
    @IBOutlet weak var lockScreenLabel: UILabel!

    var loyaltyCoupon: LoyaltyCoupon!
    
    func configureCell(loyaltyCoupon: LoyaltyCoupon) {
        self.loyaltyCoupon = loyaltyCoupon
        shadowView.dropShadow(scale: true)
        imgView.backgroundColor = UIColor.black
        imgView.clipsToBounds = true
        imgView.downloadedFrom(link: loyaltyCoupon.imgURL!)
        titleLabel.text = loyaltyCoupon.title
        subtitleLabel.text = loyaltyCoupon.subtitle
        lockScreenLabel.text = loyaltyCoupon.lockScreenText
        
        if loyaltyCoupon.redeem == true {
            self.lockScreenView.isHidden = true
        } else {
            self.lockScreenView.isHidden = false
        }
    }
    
}
