//
//  HomeVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class Heights {
    var tabBarHeight: CGFloat = 0
    var navBarHeight: CGFloat = 0
}

let heights = Heights()

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: IBOutlets

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionTransitionView: UIView!
    @IBOutlet weak var gettingStartedView: UIView!
    @IBOutlet weak var ThankYouView: UIView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noSurveyView: UIView!
    
    @IBOutlet weak var option1View: UIView!
    @IBOutlet weak var option2View: UIView!
    @IBOutlet weak var option3View: UIView!
    @IBOutlet weak var option4View: UIView!

    
    @IBOutlet weak var option1: RadioButton!
    @IBOutlet weak var option2: RadioButton!
    @IBOutlet weak var option3: RadioButton!
    @IBOutlet weak var option4: RadioButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    
    @IBOutlet weak var thankYouActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var greetingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var countViewLabel: UILabel!
    
    // MARK: Variables
    
    var brandList = [BrandCV]()
    var selectedAnswer: String!
    var quesArray: NSArray!
    var totalQuestions: Int!
    var quesIterator = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "freestandLogoWhite.png")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        
        self.questionTransitionView.isHidden = true
        heights.tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        heights.navBarHeight = (self.navigationController?.navigationBar.frame.height)!
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "CVCell", bundle: nil), forCellWithReuseIdentifier: "CVCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }

        self.ThankYouView.isHidden = true
        self.greetingActivityIndicator.isHidden = true
        
        getBrands()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func questionsLoadedCallback() {
        self.questionTransitionView.isHidden = false
        option1.isSelected = false
        option2.isSelected = false
        option3.isSelected = false
        option4.isSelected = false
        
        hideOptions()
        let quesData = quesArray[0] as? [String:String]
        if let question = quesData?["question"] {
            questionLabel.text = question
        }
        
        if let option1 = quesData?["option1"] {
            option1View.isHidden = false
            option1Label.text = option1
        }
        
        if let option2 = quesData?["option2"] {
            option2View.isHidden = false
            option2Label.text = option2
        }
        
        if let option3 = quesData?["option3"] {
            option3View.isHidden = false
            option3Label.text = option3
        }
        
        if let option4 = quesData?["option4"] {
            option4View.isHidden = false
            option4Label.text = option4
        }
        totalQuestions = quesArray.count
        countViewLabel.text = "1/\(totalQuestions!)"

        option1?.alternateButton = [option2!, option3!, option4!]
        option2?.alternateButton = [option1!, option3!, option4!]
        option3?.alternateButton = [option2!, option1!, option4!]
        option4?.alternateButton = [option2!, option3!, option1!]
        
        self.nextBtn.setTitle("NEXT", for: .normal)
        self.nextBtn.isEnabled = false
        self.nextBtn.alpha = 0.5

    }


    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as? CVCell {
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.borderWidth = 2
            
            let brand: BrandCV!
            brand = brandList[indexPath.row]
            cell.configureCell(brand: brand)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func getBrands() {
        Alamofire.request(APIEndpoints.getBrands).responseJSON { (response) in
            if let response = response.result.value as? [String: NSDictionary] {
                for (_, dict) in response {
                    let brand = BrandCV()
                    if let imgURL = dict["imgURL"] as? String {
                        brand.imgURL = imgURL
                    } else {
                        print("Error: Can't cast imgURL in CollectionView")
                    }
                    
                    if let name = dict["name"] as? String {
                        brand.name = name
                    } else {
                        print("Error: Can't cast name in CollectionView")
                    }
                    
                    if let redirectURL = dict["redirectURL"] as? String {
                        brand.redirectURL = redirectURL
                    } else {
                        print("Error: Can't cast redirectURL in CollectionView")
                    }
                    
                    self.brandList.append(brand)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = brandList[indexPath.row]
        UIApplication.shared.open(URL(string: brand.redirectURL!)!, options: [:], completionHandler: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: Feedback Options Buttons
    
    @IBAction func option1pressed(_ sender: UIButton) {
        selectedAnswer = "1"
        option1.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func option2pressed(_ sender: UIButton) {
        selectedAnswer = "2"
        option2.unselectAlternateButtons()
        enableNextBtn()
    }

    @IBAction func option3pressed(_ sender: UIButton) {
        selectedAnswer = "3"
        option3.unselectAlternateButtons()
        enableNextBtn()
    }

    @IBAction func option4pressed(_ sender: UIButton) {
        selectedAnswer = "4"
        option4.unselectAlternateButtons()
        enableNextBtn()
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if sender.title(for: .normal) == "NEXT" {
            changeQuestion()
        } else if sender.title(for: .normal) == "SUBMIT" {
            print("Aryan: Submit successful")
            hideQuestionShowThankYou()
        } else {
            print("Error: HomeVC nextBtn else block called")
        }
    }
    
    func hideQuestionShowThankYou() {
        self.ThankYouView.isHidden = false
        UIView.transition(with: questionTransitionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.questionTransitionView.isHidden = true
        }) { (flag) in
            if flag {
                self.questionTransitionView.bringSubview(toFront: self.ThankYouView)
            }
        }
    }

    
    func hideOptions() {
        option1View.isHidden = true
        option2View.isHidden = true
        option3View.isHidden = true
        option4View.isHidden = true
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
        hideOptions()
        let quesData = quesArray[quesIterator] as? [String:String]
        
        if let question = quesData?["question"] {
            questionLabel.text = question
        }
        
        if let option1 = quesData?["option1"] {
            option1View.isHidden = false
            option1Label.text = option1
        }
        
        if let option2 = quesData?["option2"] {
            option2View.isHidden = false
            option2Label.text = option2
        }
        
        if let option3 = quesData?["option3"] {
            option3View.isHidden = false
            option3Label.text = option3
        }
        
        if let option4 = quesData?["option4"] {
            option4View.isHidden = false
            option4Label.text = option4
        }
        
        countViewLabel.text = "\(quesIterator+1)/\(totalQuestions!)"
        disableNextBtn()
        resetRadioButtons()
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
    
    func hideQuestionView() {
        questionTransitionView.isHidden = true
    }

    // MARK: Getting Started View
    
    @IBAction func getStartedBtnPressed(_ sender: UIButton) {
        self.greetingActivityIndicator.isHidden = false
        self.greetingActivityIndicator.startAnimating()
        
        let url = "\(APIEndpoints.showSurveysEndpoint)?uid=\(String(describing: UserInfo.uid!))&gender=\(String(describing: UserInfo.gender!))"
        Alamofire.request(url).responseJSON { (response) in
            if let dict = response.result.value as? NSDictionary {
                if let containsFeedback = dict["containsSurvey"] as? Bool {
                    if containsFeedback {
                        if let survey = dict["survey"] as? NSDictionary {
                            self.quesArray = survey["questions"] as? NSArray
                            self.questionsLoadedCallback()
                            self.hideGreetingShowQuestions()
                            self.greetingActivityIndicator.stopAnimating()
                        } else {
                            print("Error: can't cast survey")
                        }
                    } else {
                        print("No Surveys to show")
                        self.greetingActivityIndicator.stopAnimating()
                        // Show No surveys screen
                    }
                } else {
                    print("Error: can't cast containsSurvey")
                }
            } else {
                print("Error: Can't cast responseDict")
            }
        }
    }
    
    func hideGreetingShowQuestions() {
        UIView.transition(with: gettingStartedView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.gettingStartedView.isHidden = true
        }) { (flag) in
            if flag {
                self.gettingStartedView.bringSubview(toFront: self.questionTransitionView)
            }
        }
    }
    
    // MARK: ThannkYou View
    
    @IBAction func WhatNextBtnPressed(_ sender: UIButton) {
        sender.isHidden = true
        self.quesIterator = 0
        thankYouActivityIndicator.isHidden = false
        thankYouActivityIndicator.startAnimating()
        
        let url = "\(APIEndpoints.showSurveysEndpoint)?uid=\(String(describing: UserInfo.uid!))&gender=\(String(describing: UserInfo.gender!))"
        Alamofire.request(url).responseJSON { (response) in
            if let dict = response.result.value as? NSDictionary {
                if let containsFeedback = dict["containsSurvey"] as? Bool {
                    if containsFeedback {
                        if let survey = dict["survey"] as? NSDictionary {
                            self.quesArray = survey["questions"] as? NSArray
                            self.questionsLoadedCallback()
                            self.hideThankYouShowQuestions()
                            sender.isHidden = false
                            self.thankYouActivityIndicator.stopAnimating()
                        } else {
                            print("Error: can't cast survey")
                        }
                    } else {
                        print("No Surveys to show")
                        sender.isHidden = false
                        self.thankYouActivityIndicator.stopAnimating()
                        self.thankYouLabel.text = "No Surveys Available now"
                        // Show No surveys screen
                    }
                } else {
                    print("Error: can't cast containsSurvey")
                }
            } else {
                print("Error: Can't cast responseDict")
            }
        }

    }
    
    func hideThankYouShowQuestions() {
        UIView.transition(with: ThankYouView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.ThankYouView.isHidden = true
        }) { (flag) in
            if flag {
                self.ThankYouView.bringSubview(toFront: self.questionTransitionView)
            }
        }
    }
    
    
}

