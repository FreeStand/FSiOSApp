//
//  HomeVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var NextCardView: UIView!
    @IBOutlet weak var ProductCardView: UIView!
    @IBOutlet weak var FeedbackCardView: UIView!
    @IBOutlet weak var ShareCardView: UIView!
    
    var button: String!
    let result = "test1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logoFreeStand.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        self.topCardView.layer.cornerRadius = 5
        self.NextCardView.layer.cornerRadius = 5
        self.ProductCardView.layer.cornerRadius = 5
        self.FeedbackCardView.layer.cornerRadius = 5
        self.ShareCardView.layer.cornerRadius = 5
        
        self.topCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.NextCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.ProductCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.FeedbackCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.ShareCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        
        self.topCardView.layer.borderWidth = 0.5
        self.NextCardView.layer.borderWidth = 0.5
        self.ProductCardView.layer.borderWidth = 0.5
        self.FeedbackCardView.layer.borderWidth = 0.5
        self.ShareCardView.layer.borderWidth = 0.5


        
        self.topCardView.clipsToBounds = true
        self.NextCardView.clipsToBounds = true
        self.ProductCardView.clipsToBounds = true
        self.FeedbackCardView.clipsToBounds = true
        self.ShareCardView.clipsToBounds = true
        
//        self.checkForDuplicateScan(qrCode: result)
    
    }
    
    func checkForDuplicateScan(qrCode: String) {
        DataService.ds.REF_SAMPLES.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                print(dict)
                print(qrCode)
                if let newDict = dict["\(qrCode)"] as? NSDictionary {
                    print(newDict)
                } else {
                    print("Error: Can't")
                }
            }
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }


    func goToPreviousTab(sender:UISwipeGestureRecognizer) {
        
        if sender.direction == UISwipeGestureRecognizerDirection.left {
            
            tabBarController?.selectedIndex += 1
            
        } 
        
    }

   
    @IBAction func ProductsBtnPressed(_ sender: UIButton) {
        button = "products"
        performSegue(withIdentifier: "homeToOrder", sender: UIButton.self)
    }

    @IBAction func WhatNextBtnPressed(_ sender: UIButton) {
        button = "next"
        performSegue(withIdentifier: "homeToWeb", sender: UIButton.self)
    }
    
    @IBAction func FeedbackBtnPressed(_ sender: UIButton) {
        button = "feedback"
        performSegue(withIdentifier: "homeToWeb", sender: UIButton.self)
    }
    @IBAction func ShareBtnPressed(_ sender: UIButton) {
        button = "share"
        performSegue(withIdentifier: "homeToWeb", sender: UIButton.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homeToWeb" {
            if let vc = segue.destination as? WebViewVC{
                print("0")
                if button == "next" {
                    print("1")
                    vc.url = NSURL(string: "https://www.surveymonkey.com/r/C5PRQ63")! as URL
                } else if button == "feedback"{
                    print("3")
                    vc.url = NSURL(string: "https://www.surveymonkey.com/r/CPX2NTQ")! as URL
                } else if button == "share"{
                    print("4")
                    vc.url = NSURL(string: "https://duckduckgo.com")! as URL
                }
            }
        }
    }
}
