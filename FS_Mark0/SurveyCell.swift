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
    
    var survey: Survey!

    func configureCell(survey: Survey) {
        self.survey = survey
        self.imgView.downloadedFrom(link: survey.imgURL!)
        self.titleLabel.text = survey.title
        self.subtitleLabel.text = survey.subtitle
        self.totalQuesLabel.text = "Total Questions: \(String(describing: (survey.quesArray?.count)!))"
    }

}
