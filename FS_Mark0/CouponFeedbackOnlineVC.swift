//
//  FeedbackVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class CouponFeedbackOnlineVC: UIViewController {
    
    var selectedAnswer: String!
    var selectedAnswers = [String]()
    var iterator = 2
    var brand: Brand!
    var quesDict: NSDictionary!
    var totalQuestions: Int!
    var couponCode: String!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quesDict = brand.questions
        
        option1.isSelected = true
        option2.isSelected = false
        option3.isSelected = false
        option4.isSelected = false
        option5.isSelected = false
        
        let dict = quesDict["question1"] as? [String:String]
        questionLabel.text = dict?["question"]
        option1Label.text = dict?["option1"]
        option2Label.text = dict?["option2"]
        option3Label.text = dict?["option3"]
        option4Label.text = dict?["option4"]
        option5Label.text = dict?["option5"]
        totalQuestions = quesDict.count

        countViewLabel.text = "1/\(totalQuestions!)"
        print(totalQuestions)
        progressView.progress = 1.0 / Float(totalQuestions)
        
        selectedAnswer = "1"
        option1?.alternateButton = [option2!, option3!, option4!, option5!]
        option2?.alternateButton = [option1!, option3!, option4!, option5!]
        option3?.alternateButton = [option2!, option1!, option4!, option5!]
        option4?.alternateButton = [option2!, option3!, option1!, option5!]
        option5?.alternateButton = [option2!, option3!, option4!, option1!]
        
        superView.layer.cornerRadius = 7
        countView.layer.cornerRadius = 15
        nextBtn.layer.cornerRadius = 25
        
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
        let dict = quesDict[ques] as? [String: String]
        questionLabel.text = dict?["question"]
        option1Label.text = dict?["option1"]
        option2Label.text = dict?["option2"]
        option3Label.text = dict?["option3"]
        option4Label.text = dict?["option4"]
        option5Label.text = dict?["option5"]
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
        DataService.ds.REF_USER_CURRENT.child("feedback").child("brands").child(brand.name!).child("coupon1").setValue(selectedAnswers)
        UserDefaults.standard.set("true", forKey: "\(brand.name!)fb")

    }
    
    @IBAction func nextBtnpressed(_ sender: UIButton) {
        selectedAnswers.append(selectedAnswer)
        if sender.title(for: .normal) == "NEXT" {
            changeQuestion()
        } else if sender.title(for: .normal) == "SUBMIT" {
            
            updateDB()
            performSegue(withIdentifier: "toCouponCode", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCouponCode" {
            if let vc = segue.destination as? CouponDigitalVC {
                vc.couponCode = self.couponCode
            }
        }
    }
    
}


