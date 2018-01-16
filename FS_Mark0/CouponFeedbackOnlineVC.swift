//
//  FeedbackVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class CouponFeedbackOnlineVC: UIViewController {
    

    // MARK: Variables
    var selectedAnswer: String!
    var quesDict: NSDictionary!
    var totalQuestions: Int!
    var quesIterator = 0
    var surveyID: String!
    var couponCode: String!
    // MARK: Outlets
    
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionTransitionView: UIView!
    
    @IBOutlet weak var option1: RadioButton!
    @IBOutlet weak var option2: RadioButton!
    @IBOutlet weak var option3: RadioButton!
    @IBOutlet weak var option4: RadioButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var countViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Analytics.logEvent(Events.SCREEN_QR_FEED, parameters: nil)
        if quesDict != nil {
            questionsLoadedCallback()
        }
        questionTransitionView.layer.cornerRadius = 7
        countView.layer.cornerRadius = 15
        nextBtn.layer.cornerRadius = 25
        self.nextBtn.setTitle("NEXT", for: .normal)
    }
    
    func questionsLoadedCallback() {
        option1.isSelected = false
        option2.isSelected = false
        option3.isSelected = false
        option4.isSelected = false
        
        let dict = quesDict["question1"] as? [String:String]
        questionLabel.text = dict?["question"]
        option1Label.text = dict?["option1"]
        option2Label.text = dict?["option2"]
        option3Label.text = dict?["option3"]
        option4Label.text = dict?["option4"]
        
        totalQuestions = quesDict.count
        countViewLabel.text = "1/\(totalQuestions!)"
        
        option1?.alternateButton = [option2!, option3!, option4!]
        option2?.alternateButton = [option1!, option3!, option4!]
        option3?.alternateButton = [option2!, option1!, option4!]
        option4?.alternateButton = [option2!, option3!, option1!]
        
        self.nextBtn.setTitle("NEXT", for: .normal)
        self.nextBtn.isEnabled = false
        self.nextBtn.alpha = 0.5
        self.questionTransitionView.isHidden = false
        
    }
    
    //MARK: Questions Algo
    
    func changeQuestion() {
        quesIterator += 1
        if quesIterator < totalQuestions - 1 {
            UIView.transition(with: self.questionTransitionView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.updateQuestion()
            }, completion: nil)
        } else if quesIterator == totalQuestions - 1 {
            UIView.transition(with: self.questionTransitionView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.updateQuestion()
                self.nextBtn.setTitle("SUBMIT", for: .normal)
            }, completion: nil)
        } else {
            print("Error: HomeVC changeQuestion quesIterator >= totalQuestions")
        }
    }
    
    func updateQuestion() {
        let quesData = quesDict.allValues[quesIterator] as? [String:String]
        questionLabel.text = quesData?["question"]
        option1Label.text = quesData?["option1"]
        option2Label.text = quesData?["option2"]
        option3Label.text = quesData?["option3"]
        option4Label.text = quesData?["option4"]
        countViewLabel.text = "\(quesIterator+1)/\(totalQuestions!)"
        disableNextBtn()
        resetRadioButtons()
    }
    
    @IBAction func nextBtnpressed(_ sender: UIButton) {
//        Analytics.logEvent("\(surveyID!)_ques\(quesIterator)_\(selectedAnswer!)",
//            parameters: ["uid":Auth.auth().currentUser?.uid as Any])
        
        if sender.title(for: .normal) == "NEXT" {
            changeQuestion()
        } else if sender.title(for: .normal) == "SUBMIT" {
            updateDB()
        }
    }
    
    func updateDB() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ThankYouVC = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
        self.present(ThankYouVC, animated: true, completion: nil)
    }
    
    
    @IBAction func button1pressed(_ sender: Any) {
        selectedAnswer = "1"
        option1.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func button2pressed(_ sender: Any) {
        selectedAnswer = "2"
        option2.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func button3pressed(_ sender: Any) {
        selectedAnswer = "3"
        option3.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func button4pressed(_ sender: Any) {
        selectedAnswer = "4"
        option4.unselectAlternateButtons()
        enableNextBtn()
    }
    
    //MARK: Miscellaneous
    
    func enableNextBtn() {
        if !nextBtn.isEnabled {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    func disableNextBtn() {
        if nextBtn.isEnabled {
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.5
        }
    }
    
    func resetRadioButtons() {
        option1.setImage(UIImage(named: "radioOff"), for: .normal)
        option2.setImage(UIImage(named: "radioOff"), for: .normal)
        option3.setImage(UIImage(named: "radioOff"), for: .normal)
        option4.setImage(UIImage(named: "radioOff"), for: .normal)
    }

}


