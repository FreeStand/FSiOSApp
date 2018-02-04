//
//  AlertCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 24/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var alert: Alert!
    
    func configureCell(alert: Alert) {
        self.alert = alert
        timeLabel.text = alert.time
        titleLabel.text = alert.title
        subtitleLabel.text = alert.body
        
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
