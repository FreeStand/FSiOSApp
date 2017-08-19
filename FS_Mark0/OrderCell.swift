//
//  OrderCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 12/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    
    var time: String?
    var imgUrl: URL?
    var order: Order!
    
    func configureCell(order: Order) {
        self.order = order
        time = self.order.time!
        timeLabel.text = "Collected on " + time!
    }

}
