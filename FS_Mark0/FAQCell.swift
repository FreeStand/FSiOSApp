//
//  FAQCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {
    
    @IBOutlet weak var quesLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var faq: FAQ!
    
    func configureCell(faq: FAQ) {
        self.faq = faq
        quesLabel.text = faq.question
        answerLabel.text = faq.answer
    }
    
}
