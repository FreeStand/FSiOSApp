//
//  CouponDigitalVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 07/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class CouponDigitalVC: UIViewController {

    var couponCode: String!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var backgroundImg: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneBtn.layer.cornerRadius = 4
        copyBtn.layer.cornerRadius = 2
        couponLbl.text = couponCode
        backgroundImg.clipsToBounds = true
    }
    
    @IBAction func copyBtnPressed(_ sender: Any) {
        UIPasteboard.general.string = couponCode
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
