//
//  CollegeCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 10/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class CollegeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var college: College!
    
    func configureCell(college: College) {
        self.college = college
        nameLabel.text = college.name
        
        self.shadowView.layer.cornerRadius = 2.0
        self.shadowView.layer.borderWidth = 1.0
        self.shadowView.layer.borderColor = UIColor.clear.cgColor
        self.shadowView.layer.masksToBounds = true

        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize.zero
        self.shadowView.layer.shadowRadius = 1.0
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.masksToBounds = false
//        self.shadowView.layer.shadowPath = UIBezierPath(rect: self.shadowView.bounds).cgPath
        self.shadowView.layer.shouldRasterize = true

    }

}
