//
//  FeedbackVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import FirebaseAnalytics
import UIKit
import FirebaseAuth

class FeedbackVC: UIViewController {

    // MARK: Variables
    var selectedAnswer: String!
    var quesDict: NSDictionary!
    var quesArray: NSArray!
    var totalQuestions: Int!
    var quesIterator = 0
    var surveyID: String!
    var sender: String!
    var couponCode: String!
    var selectedState: QuestionType!
    var selectedCheckBoxes = [String]()
    var counter = 0.0
    var timer = Timer()
    
    enum QuestionType {
        case check, radio
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionTransitionView: UIView!
    @IBOutlet weak var checkBoxView: UIView!
    
    @IBOutlet weak var option1: RadioButton!
    @IBOutlet weak var option2: RadioButton!
    @IBOutlet weak var option3: RadioButton!
    @IBOutlet weak var option4: RadioButton!
    @IBOutlet weak var option5: RadioButton!
    @IBOutlet weak var option6: RadioButton!
    @IBOutlet weak var option7: RadioButton!
    @IBOutlet weak var option8: RadioButton!

    @IBOutlet weak var checkbox1: CheckBox!
    @IBOutlet weak var checkbox2: CheckBox!
    @IBOutlet weak var checkbox3: CheckBox!
    @IBOutlet weak var checkbox4: CheckBox!
    @IBOutlet weak var checkbox5: CheckBox!
    @IBOutlet weak var checkbox6: CheckBox!
    @IBOutlet weak var checkbox7: CheckBox!
    @IBOutlet weak var checkbox8: CheckBox!

    @IBOutlet weak var checkbox1View: UIView!
    @IBOutlet weak var checkbox2View: UIView!
    @IBOutlet weak var checkbox3View: UIView!
    @IBOutlet weak var checkbox4View: UIView!
    @IBOutlet weak var checkbox5View: UIView!
    @IBOutlet weak var checkbox6View: UIView!
    @IBOutlet weak var checkbox7View: UIView!
    @IBOutlet weak var checkbox8View: UIView!
    
    @IBOutlet weak var checkbox1Label: UILabel!
    @IBOutlet weak var checkbox2Label: UILabel!
    @IBOutlet weak var checkbox3Label: UILabel!
    @IBOutlet weak var checkbox4Label: UILabel!
    @IBOutlet weak var checkbox5Label: UILabel!
    @IBOutlet weak var checkbox6Label: UILabel!
    @IBOutlet weak var checkbox7Label: UILabel!
    @IBOutlet weak var checkbox8Label: UILabel!


    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!
    @IBOutlet weak var option5Label: UILabel!
    @IBOutlet weak var option6Label: UILabel!
    @IBOutlet weak var option7Label: UILabel!
    @IBOutlet weak var option8Label: UILabel!

    
    @IBOutlet weak var option1View: UIView!
    @IBOutlet weak var option2View: UIView!
    @IBOutlet weak var option3View: UIView!
    @IBOutlet weak var option4View: UIView!
    @IBOutlet weak var option5View: UIView!
    @IBOutlet weak var option6View: UIView!
    @IBOutlet weak var option7View: UIView!
    @IBOutlet weak var option8View: UIView!


    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var countViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(Events.SCREEN_QR_FEED, parameters: nil)
        if quesArray != nil {
            questionsLoadedCallback()
        }
        totalQuestions = quesArray.count
        questionTransitionView.layer.cornerRadius = 7
        nextBtn.layer.cornerRadius = 7
        checkBoxView.isHidden = true
//        questionTransitionView.isHidden = true
        checkBoxView.layer.cornerRadius = 7
        self.nextBtn.setTitle("NEXT", for: .normal)
        self.nextBtn.isEnabled = false
        
        option1?.alternateButton = [option2!, option3!, option4!, option5!, option6!, option7!, option8!]
        option2?.alternateButton = [option1!, option3!, option4!, option5!, option6!, option7!, option8!]
        option3?.alternateButton = [option2!, option1!, option4!, option5!, option6!, option7!, option8!]
        option4?.alternateButton = [option2!, option3!, option1!, option5!, option6!, option7!, option8!]
        option5?.alternateButton = [option2!, option3!, option1!, option4!, option6!, option7!, option8!]
        option6?.alternateButton = [option2!, option3!, option1!, option5!, option4!, option7!, option8!]
        option7?.alternateButton = [option2!, option3!, option1!, option5!, option6!, option4!, option8!]
        option8?.alternateButton = [option2!, option3!, option1!, option5!, option6!, option7!, option4!]

    }
    
    func questionsLoadedCallback() {
        print("Aryan: questionsLoadedCallback")
        let quesData = quesArray[quesIterator] as? [String:String]
        if let type = quesData?["type"] {
            if type == "single_choice" {
                startTimer()
                questionTransitionView.isHidden = false
                checkBoxView.isHidden = true
                self.loadRadioButtons()
            } else if type == "multiple_choice"{
                startTimer()
                checkBoxView.isHidden = false
                questionTransitionView.isHidden = true
                self.loadCheckBoxes()
            }
        }
    }
    
    func loadRadioButtons() {
        print("Aryan: loadRadioButtons")
        questionTransitionView.isHidden = false
        selectedState = QuestionType.radio
        updateCountLabel()
        resetRadioButtons()
        hideOptions()

        let quesData = quesArray[quesIterator] as? [String:String]
        
        if let question = quesData?["question"] {
            questionLabel.text = question
        } else {
            print("Aryan: Can't load questions in radioButtons in FeedbackVC")
        }
        
        if let option1 = quesData!["option1"] {
            print(option1)
            option1View.isHidden = false
            option1Label.text = option1
        } else {
            print("Aryan: Can't load option1 in radioButtons in FeedbackVC")
        }

        
        if let option2 = quesData?["option2"] {
            option2View.isHidden = false
            option2Label.text = option2
        } else {
            print("Aryan: Can't load option2 in radioButtons in FeedbackVC")
        }

        
        if let option3 = quesData?["option3"] {
            option3View.isHidden = false
            option3Label.text = option3
        } else {
            print("Aryan: Can't load option3 in radioButtons in FeedbackVC")
        }

        
        if let option4 = quesData?["option4"] {
            option4View.isHidden = false
            option4Label.text = option4
        } else {
            print("Aryan: Can't load option4 in radioButtons in FeedbackVC")
        }

        
        if let option5 = quesData?["option5"] {
            option5View.isHidden = false
            option5Label.text = option5
        } else {
            print("Aryan: Can't load option5 in radioButtons in FeedbackVC")
        }

        
        if let option6 = quesData?["option6"] {
            option6View.isHidden = false
            option6Label.text = option6
        } else {
            print("Aryan: Can't load option6 in radioButtons in FeedbackVC")
        }

        
        if let option7 = quesData?["option7"] {
            option7View.isHidden = false
            option7Label.text = option7
        } else {
            print("Aryan: Can't load option7 in radioButtons in FeedbackVC")
        }

        
        if let option8 = quesData?["option8"] {
            option8View.isHidden = false
            option8Label.text = option8
        } else {
            print("Aryan: Can't load option8 in radioButtons in FeedbackVC")
        }

        print("Aryan \(questionTransitionView.isHidden)")
    }
    
    func loadCheckBoxes() {
        print("Aryan: loadCheckBoxes")
        checkBoxView.isHidden = false
        selectedState = QuestionType.check
        updateCountLabel()
        resetCheckBoxes()
        hideCheckBoxes()
        let quesData = quesArray[quesIterator] as? [String:String]
        if let question = quesData?["question"] {
            questionLabel.text = question
        }
        
        if let option1 = quesData?["option1"] {
            checkbox1View.isHidden = false
            checkbox1Label.text = option1
        }
        
        if let option2 = quesData?["option2"] {
            checkbox2View.isHidden = false
            checkbox2Label.text = option2
        }
        
        if let option3 = quesData?["option3"] {
            checkbox3View.isHidden = false
            checkbox3Label.text = option3
        }
        
        if let option4 = quesData?["option4"] {
            checkbox4View.isHidden = false
            checkbox4Label.text = option4
        }
        
        if let option5 = quesData?["option5"] {
            checkbox5View.isHidden = false
            checkbox5Label.text = option5
        }
        
        if let option6 = quesData?["option6"] {
            checkbox6View.isHidden = false
            checkbox6Label.text = option6
        }
        
        if let option7 = quesData?["option7"] {
            checkbox7View.isHidden = false
            checkbox7Label.text = option7
        }
        
        if let option8 = quesData?["option8"] {
            checkbox8View.isHidden = false
            checkbox8Label.text = option8
        }
        checkBoxView.isHidden = false
    }
    
    func updateCountLabel() {
        totalQuestions = quesArray.count
        countViewLabel.text = "\(quesIterator + 1)/\(totalQuestions!)"
        progressView.progress = Float(quesIterator + 1) / Float (totalQuestions!)
    }
    

    //MARK: Questions Algo
    
    func changeQuestion() {
        quesIterator += 1
        let quesData = quesArray[quesIterator] as? [String:String]
        if let type = quesData?["type"] {
            let fromView = self.getCurrentView()
            if type == "single_choice" {
                self.loadRadioButtons()
                if fromView == self.questionTransitionView {
                    UIView.transition(with: self.questionTransitionView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: { (flag) in
                        if flag {
                            if self.quesIterator == self.totalQuestions - 1 {
                                self.nextBtn.setTitle("SUBMIT", for: .normal)
                            }
                        }
                    })
                } else {
                    self.checkBoxView.isHidden = true
                    self.questionTransitionView.isHidden = true
                UIView.transition(from: self.checkBoxView, to: self.questionTransitionView, duration: 0.3, options: .transitionFlipFromRight, completion: { (flag) in
                    if flag {
                        if self.quesIterator == self.totalQuestions - 1 {
                            self.nextBtn.setTitle("SUBMIT", for: .normal)
                        }
                    }
                })
                }
            } else if type == "multiple_choice" {
                self.loadCheckBoxes()
                if fromView == self.questionTransitionView {
                    self.questionTransitionView.isHidden = true
                    self.checkBoxView.isHidden = false
                    UIView.transition(from: self.questionTransitionView, to: self.checkBoxView, duration: 0.3, options: .transitionFlipFromRight, completion: { (flag) in
                        if flag {
                            if self.quesIterator == self.totalQuestions - 1 {
                                self.nextBtn.setTitle("SUBMIT", for: .normal)
                            }
                        }
                    })
                } else {
                    UIView.transition(with: self.checkBoxView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: { (flag) in
                        if flag {
                            if self.quesIterator == self.totalQuestions - 1 {
                                self.nextBtn.setTitle("SUBMIT", for: .normal)
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func nextBtnpressed(_ sender: UIButton) {
//        Analytics.logEvent("\(surveyID!)_ques\(quesIterator)",
//            parameters: ["answer": selectedAnswer])
        disableNextBtn()
        
        if selectedState == QuestionType.radio {
            print(selectedAnswer)
        } else {
            checkBoxAnswer()
        }
        
        if sender.title(for: .normal) == "NEXT" {
            changeQuestion()
        } else if sender.title(for: .normal) == "SUBMIT" {
            handleSubmit()
        }
    }
    
    func handleSubmit() {
        stopTimer()
        print("Aryan: Total Time taken = \(counter) seconds.")
        if sender == "Coupon" {
            // push couponDetailVC
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let CouponDigitalVC = storyBoard.instantiateViewController(withIdentifier: "CouponDigitalVC") as! CouponDigitalVC
            CouponDigitalVC.couponCode = self.couponCode
            self.navigationController?.pushViewController(CouponDigitalVC, animated: true)
        } else if sender == "InitialQR" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ThankYouVC = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
            self.present(ThankYouVC, animated: true, completion: nil)
        } else if sender == "QR" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ThankYouVC = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
            self.present(ThankYouVC, animated: true, completion: nil)

        } else if sender == "HomeTVC"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ThankYouVC = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
            self.present(ThankYouVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func check1pressed(_ sender: UIButton) {
        print("Aryan: CheckPressed")
        checkbox1.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
 
    @IBAction func check2pressed(_ sender: UIButton) {
        print("Aryan: CheckPressed")
        checkbox2.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
    
    @IBAction func check3pressed(_ sender: UIButton) {
        print("Aryan: CheckPressed")
        checkbox3.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
    
    @IBAction func check4pressed(_ sender: UIButton) {
        print("Aryan: CheckPressed")
        checkbox4.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
    
    @IBAction func check5pressed(_ sender: UIButton) {
        print("Aryan: CheckPressed")
        checkbox5.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
    
    @IBAction func check6pressed(_ sender: UIButton) {
        checkbox6.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
    
    @IBAction func check7pressed(_ sender: UIButton) {
        checkbox7.sendActions(for: .touchUpInside)
        enableNextBtn()
    }
    
    @IBAction func check8pressed(_ sender: UIButton) {
        checkbox8.sendActions(for: .touchUpInside)
        enableNextBtn()
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
    
    @IBAction func button5pressed(_ sender: Any) {
        selectedAnswer = "5"
        option5.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func button6pressed(_ sender: Any) {
        selectedAnswer = "6"
        option6.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func button7pressed(_ sender: Any) {
        selectedAnswer = "7"
        option7.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func button8pressed(_ sender: Any) {
        selectedAnswer = "8"
        option8.unselectAlternateButtons()
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
        option1.isSelected = false
        option2.isSelected = false
        option3.isSelected = false
        option4.isSelected = false
        option5.isSelected = false
        option6.isSelected = false
        option7.isSelected = false
        option8.isSelected = false

        option1.setImage(UIImage(named: "radioOff"), for: .normal)
        option2.setImage(UIImage(named: "radioOff"), for: .normal)
        option3.setImage(UIImage(named: "radioOff"), for: .normal)
        option4.setImage(UIImage(named: "radioOff"), for: .normal)
        option5.setImage(UIImage(named: "radioOff"), for: .normal)
        option6.setImage(UIImage(named: "radioOff"), for: .normal)
        option7.setImage(UIImage(named: "radioOff"), for: .normal)
        option8.setImage(UIImage(named: "radioOff"), for: .normal)

    }

    func resetCheckBoxes() {
        checkbox1.isChecked = false
        checkbox2.isChecked = false
        checkbox3.isChecked = false
        checkbox4.isChecked = false
        checkbox5.isChecked = false
        checkbox6.isChecked = false
        checkbox7.isChecked = false
        checkbox8.isChecked = false

        checkbox1.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox2.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox3.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox4.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox5.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox6.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox7.setImage(UIImage(named: "check_off"), for: .normal)
        checkbox8.setImage(UIImage(named: "check_off"), for: .normal)
    }

    
    func hideCheckBoxes() {
        checkbox1View.isHidden = true
        checkbox2View.isHidden = true
        checkbox3View.isHidden = true
        checkbox4View.isHidden = true
        checkbox5View.isHidden = true
        checkbox6View.isHidden = true
        checkbox7View.isHidden = true
        checkbox8View.isHidden = true
    }
    
    func hideOptions() {
        option1View.isHidden = true
        option2View.isHidden = true
        option3View.isHidden = true
        option4View.isHidden = true
        option5View.isHidden = true
        option6View.isHidden = true
        option7View.isHidden = true
        option8View.isHidden = true

    }
    
    func checkBoxAnswer() {
        if checkbox1.isChecked {
            selectedCheckBoxes.append("1")
        }
        
        if checkbox2.isChecked {
            selectedCheckBoxes.append("2")
        }
        
        if checkbox3.isChecked {
            selectedCheckBoxes.append("3")
        }
        
        if checkbox4.isChecked {
            selectedCheckBoxes.append("4")
        }
        
        if checkbox5.isChecked {
            selectedCheckBoxes.append("5")
        }
        
        if checkbox6.isChecked {
            selectedCheckBoxes.append("6")
        }
        
        if checkbox7.isChecked {
            selectedCheckBoxes.append("7")
        }
        
        if checkbox8.isChecked {
            selectedCheckBoxes.append("8")
        }
        
        print(selectedCheckBoxes)
    }
    
    func getCurrentView() -> UIView {
        print("Aryan: getCurrentView")
        if selectedState == QuestionType.radio {
            return self.questionTransitionView
        } else if selectedState == QuestionType.check {
            return self.checkBoxView
        }
        
        return UIView()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func updateTimer() {
        counter = counter + 0.1
    }
}
