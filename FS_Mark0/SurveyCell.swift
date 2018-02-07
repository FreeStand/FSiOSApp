//
//  SurveyCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 31/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class SurveyCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var totalQuesLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var survey: Survey!

    func configureCell(survey: Survey) {
        self.survey = survey
        self.imgView.downloadedFrom(link: survey.imgURL!)
        self.titleLabel.text = survey.title
        self.subtitleLabel.text = survey.subtitle
        if survey.quesArray != nil {
            self.totalQuesLabel.text = "Total Questions: \(String(describing: (survey.quesArray?.count)!))"
        } else {
            self.totalQuesLabel.text = ""
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

}
