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
    
    var alert: Alert!
    
    func configureCell(alert: Alert) {
        self.alert = alert
        timeLabel.text = alert.time
        titleLabel.text = alert.title
        subtitleLabel.text = alert.body
    }

}
