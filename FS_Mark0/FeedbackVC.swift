//
//  FeedbackVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController {

    var selectedAnswer: String!
    var selectedAnswers = [String]()
    var iterator = 2
    var quesDict = ["question1":
                        ["question": "Which of these do you prefer?",
                         "option1": "Protien Chips",
                         "option2": "Protien Bars",
                         "option3": "Protien Cookies",
                         "option4": "Protien Shakes",
                         "option5": "I'm not into healthy stuff"
                        ],
                    "question2":
                        ["question": "This is question 2",
                         "option1": "This is option 1 of question 2",
                         "option2": "This is option 2 of question 2",
                         "option3": "This is option 3 of question 2",
                         "option4": "This is option 4 of question 2",
                         "option5": "This is option 5 of question 2"
                        ],
                    "question3":
                        ["question": "This is question 3",
                         "option1": "This is option 1 of question 3",
                         "option2": "This is option 2 of question 3",
                         "option3": "This is option 3 of question 3",
                         "option4": "This is option 4 of question 3",
                         "option5": "This is option 5 of question 3"
                        ],
                    "question4":
                        ["question": "This is question 4",
                         "option1": "This is option 1 of question 4",
                         "option2": "This is option 2 of question 4",
                         "option3": "This is option 3 of question 4",
                         "option4": "This is option 4 of question 4",
                         "option5": "This is option 5 of question 4"
                        ]
                   ]
    
    var totalQuestions: Int!

    
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var option1: RadioButton!
    @IBOutlet weak var option2: RadioButton!
    @IBOutlet weak var option3: RadioButton!
    @IBOutlet weak var option4: RadioButton!
    @IBOutlet weak var option5: RadioButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!
    @IBOutlet weak var option5Label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var countViewLabel: UILabel!

    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        option1.isSelected = true
        option2.isSelected = false
        option3.isSelected = false
        option4.isSelected = false
        option5.isSelected = false

        let dict = quesDict["question1"]!
        questionLabel.text = dict["question"]
        option1Label.text = dict["option1"]
        option2Label.text = dict["option2"]
        option3Label.text = dict["option3"]
        option4Label.text = dict["option4"]
        option5Label.text = dict["option5"]
        countViewLabel.text = "1/\(totalQuestions!)"
        progressView.progress = 1 / Float(totalQuestions)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        totalQuestions = quesDict.count
        selectedAnswer = "1"
        option1?.alternateButton = [option2!, option3!, option4!, option5!]
        option2?.alternateButton = [option1!, option3!, option4!, option5!]
        option3?.alternateButton = [option2!, option1!, option4!, option5!]
        option4?.alternateButton = [option2!, option3!, option1!, option5!]
        option5?.alternateButton = [option2!, option3!, option4!, option1!]
        
        superView.layer.cornerRadius = 7
        countView.layer.cornerRadius = 15
        nextBtn.layer.cornerRadius = 25
        navigationController?.navigationBar.barTintColor = UIColor.fiBlueBar
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = UIColor.white

        
        self.navigationItem.title = "FeedBack"
        self.nextBtn.setTitle("NEXT", for: .normal)


    }
    
    func updateQuestion(ques: String) {
        print(ques)
        let dict = quesDict[ques]!
        questionLabel.text = dict["question"]
        option1Label.text = dict["option1"]
        option2Label.text = dict["option2"]
        option3Label.text = dict["option3"]
        option4Label.text = dict["option4"]
        option5Label.text = dict["option5"]
        countViewLabel.text = "\(iterator - 1)/\(totalQuestions!)"
        progressView.progress = Float(iterator - 1) / Float(totalQuestions)

    }
    
    func changeQuestion() {
        var ques: String!
        ques = "question"+"\(iterator)"
        if(iterator < totalQuestions) {
            iterator = iterator + 1
            UIView.transition(with: self.superView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.updateQuestion(ques: ques)
            }, completion: nil)
        } else if iterator == totalQuestions {
            UIView.transition(with: self.superView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.updateQuestion(ques: ques)
            }, completion: nil)
            countViewLabel.text = "\(totalQuestions!)/\(totalQuestions!)"
            progressView.progress = 1.0
            self.nextBtn.setTitle("SUBMIT", for: .normal)
        }
    }
    
    func updateDB() {
        
    }
    
    @IBAction func nextBtnpressed(_ sender: UIButton) {
        selectedAnswers.append(selectedAnswer)
        if sender.title(for: .normal) == "NEXT" {
            changeQuestion()
        } else if sender.title(for: .normal) == "SUBMIT" {
            performSegue(withIdentifier: "FeedbackToThankyou", sender: self)
            print(selectedAnswers)
        }
    }

    @IBAction func button1pressed(_ sender: Any) {
        selectedAnswer = "1"
        option1.unselectAlternateButtons()
    }
    
    @IBAction func button2pressed(_ sender: Any) {
        selectedAnswer = "2"
        option2.unselectAlternateButtons()
    }
    
    @IBAction func button3pressed(_ sender: Any) {
        selectedAnswer = "3"
        option3.unselectAlternateButtons()
    }
    
    @IBAction func button4pressed(_ sender: Any) {
        selectedAnswer = "4"
        option4.unselectAlternateButtons()
    }
    
    @IBAction func button5pressed(_ sender: Any) {
        selectedAnswer = "5"
        option5.unselectAlternateButtons()
    }
    
}
