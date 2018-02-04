//
//  AddressCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 02/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class AddressCell: UICollectionViewCell {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var pincodeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    let screenWidth = UIScreen.main.bounds.size.width

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint.constant = (screenWidth - 4*8)/2
        heightConstraint.constant = widthConstraint.constant
    }
    
    func configureCell(address: Address) {
        self.nickNameLabel.text = address.nickName
        self.address1Label.text = address.address1
        self.address2Label.text = address.address2!
        self.cityLabel.text = address.city
        self.pincodeLabel.text = address.pincode
        self.stateLabel.text = address.state
    }

}
