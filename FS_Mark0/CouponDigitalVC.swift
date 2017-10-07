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
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.layer.cornerRadius = 8
        doneBtn.layer.cornerRadius = 8
        couponLbl.text = couponCode
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
