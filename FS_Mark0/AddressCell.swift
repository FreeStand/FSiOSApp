//
//  AddressCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 09/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var AddressLine1label: UILabel!
    @IBOutlet weak var AddressLine2label: UILabel!
    @IBOutlet weak var Citylabel: UILabel!
    @IBOutlet weak var Statelabel: UILabel!
    @IBOutlet weak var Pincodelabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    var address: Address!
    
    func configureCell(address: Address) {
        self.address = address
        nicknameLabel.text = address.nickName
        AddressLine1label.text = address.addressLine1
        AddressLine2label.text = address.addressLine2!
        Citylabel.text = address.city
        Statelabel.text = address.state
        Pincodelabel.text = address.pincode
        
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

}
