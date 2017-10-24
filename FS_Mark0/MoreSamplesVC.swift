//
//  MoreSamplesVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class MoreSamplesVC: UIViewController {
    
    var selectedAnswer: String!
    var selectedAnswers = [String]()
    var iterator = 2
    var brandList = [Brand]()
    var quesDict: NSDictionary!
    var totalQuestions: Int!
    var couponCode: String!
    
    
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var option1: RadioButton!
    @IBOutlet weak var option2: RadioButton!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var countViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        option1.isSelected = true
        option2.isSelected = false
        
        questionLabel.text = "Did you like the product from \(brandList[0].name ?? "Brand Name")?"
        imgView.downloadedFrom(link: brandList[0].imgUrl!)
        totalQuestions = brandList.count
        
        countViewLabel.text = "1/\(totalQuestions!)"
        print(totalQuestions)
        progressView.progress = 1.0 / Float(totalQuestions)
        
        selectedAnswer = "1"
        option1?.alternateButton = [option2!]
        option2?.alternateButton = [option1!]
        
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
    
    var i = 0
    
    func updateQuestion() {
        questionLabel.text = "Did you like the product from \(brandList[i].name ?? "Brand Name") ?"
        imgView.downloadedFrom(link: brandList[i].imgUrl!)
        countViewLabel.text = "\(iterator - 1)/\(totalQuestions!)"
        progressView.progress = Float(iterator - 1) / Float(totalQuestions)
    }
    
    func changeQuestion() {
        i = i + 1
        if(iterator < totalQuestions) {
            iterator = iterator + 1
            UIView.transition(with: self.superView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.updateQuestion()
            }, completion: nil)
        } else if iterator == totalQuestions {
            UIView.transition(with: self.superView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.updateQuestion()
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
            print(selectedAnswers)
            performSegue(withIdentifier: "moreSamplesToAddress", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBarCode" {
            if let vc = segue.destination as? CouponDetailVC {
                vc.couponCode = self.couponCode
            }
        }
    }
    
}



