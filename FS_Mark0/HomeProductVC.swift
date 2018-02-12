//
//  HomeProductVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 11/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class count {
    public static var count = 0
}


class HomeProductVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalWorthLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var comingUpView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var boxLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var productList = [Product]()
    var surveyID: String!
    var quesArray: NSArray!
    var sender: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        let sideMenuNC = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideMenuNC
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.35
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.90
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.fiBlack
        SideMenuManager.default.menuWidth = 220
        
        self.shadowView.layer.cornerRadius = 2.0
        self.shadowView.layer.borderWidth = 1.0
        self.shadowView.layer.borderColor = UIColor.clear.cgColor
        self.shadowView.layer.masksToBounds = true
        
        self.comingUpView.layer.cornerRadius = 2.0
        self.comingUpView.layer.borderWidth = 1.0
        self.comingUpView.layer.borderColor = UIColor.clear.cgColor
        self.comingUpView.layer.masksToBounds = true

        
        self.tableView.tableFooterView = UIView()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "freestandLogoWhite.png")
        imageView.image = image
        navigationItem.titleView = imageView
        self.comingUpView.isHidden = true
        self.shadowView.isHidden = true
        
        let swipeButtonRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(HomeProductVC.buttonRight))
        swipeButtonRight.direction = UISwipeGestureRecognizerDirection.right
        self.swipeView.addGestureRecognizer(swipeButtonRight)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if count.count > 0 {
            getProducts()
        }
        count.count += 1
    }
    
    @objc func buttonRight () {
        if self.quesArray != nil && self.surveyID != nil {
            if self.sender == FeedbackSender.preSampling {
                self.swipeLabel.text = "INITIATING LAUNCH IN 3.."
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                    self.swipeLabel.text = "INITIATING LAUNCH IN 3..2.."
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                        self.swipeLabel.text = "INITIATING LAUNCH IN 3..2..1.."
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                            let FeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                            FeedbackVC?.quesArray = self.quesArray
                            FeedbackVC?.surveyID = self.surveyID
                            self.surveyID = nil
                            self.quesArray = nil
                            FeedbackVC?.sender = self.sender
                            self.navigationController?.pushViewController(FeedbackVC!, animated: true)
                            self.swipeLabel.text = ">>> SWIPE TO COLLECT !! >>>"
                        })
                    })
                })
            } else if self.sender == FeedbackSender.postSampling {
                self.swipeLabel.text = "HUM AAPKE AABHAARI HAI"
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                    self.swipeLabel.text = "HUM AAPKE AABHAARI HAI."
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                        self.swipeLabel.text = "HUM AAPKE AABHAARI HAI.."
                        let FeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                        FeedbackVC?.quesArray = self.quesArray
                        FeedbackVC?.surveyID = self.surveyID
                        self.surveyID = nil
                        self.quesArray = nil
                        FeedbackVC?.sender = self.sender
                        self.navigationController?.pushViewController(FeedbackVC!, animated: true)
                        self.swipeLabel.text = ">>> SWIPE TO COLLECT !! >>>"
                    })
                })
            }
        } else {
            self.swipeLabel.text = "HAHAHAHAHAHA"
            self.swipeView.backgroundColor = UIColor.fiYellow
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.swipeLabel.text = ">>> DO NOT SWIPE !! >>>"
                self.swipeView.backgroundColor = UIColor.red
            })
        }
    }
    
    func getProducts() {
        let gender = UserDefaults.standard.string(forKey: "userGender")
        self.swipeLabel.text = "LOADING..."
        self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#5B86FF")
        Alamofire.request("\(APIEndpoints.newHomeEndpoint)?uid=\(UserInfo.uid!)&gender=\(gender!)").responseJSON { (response) in
            if let res = response.result.value as? NSDictionary {
                if let isEmpty = res["isEmpty"] as? Bool, let surveyType = res["surveyType"] as? String {
                    if !isEmpty {
                        if surveyType == "pre"{
                            if let survey = res["survey"] as? NSDictionary {
                                if let products = survey["products"] as? [[String:String]] {
                                    self.productList.removeAll()
                                    for aProduct in products {
                                        let product = Product()
                                        product.name = aProduct["name"]
                                        product.imgURL = aProduct["imgURL"]
                                        product.price = aProduct["price"]
                                        
                                        self.productList.append(product)
                                        self.shadowView.isHidden = false
                                        self.comingUpView.isHidden = true
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                            self.updatePriceLabel()
                                        }
                                    }
                                }
                                self.surveyID = nil
                                self.quesArray = nil

                                self.quesArray = survey["questions"] as? NSArray
                                self.surveyID = survey["surveyID"] as? String
                                self.sender = FeedbackSender.preSampling
                                self.swipeLabel.text = ">>> SWIPE TO COLLECT !! >>>"
                                self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#5B86FF")
                            } else {
                                print("Error: Can't cast survey")
                            }
                        } else if surveyType == "post" {
                            if let postSurvey = res["survey"] as? NSDictionary {
                                self.surveyID = nil
                                self.quesArray = nil
                                self.quesArray = postSurvey["questions"] as? NSArray
                                self.surveyID = postSurvey["surveyID"] as? String
                                self.sender = FeedbackSender.postSampling
                                self.shadowView.isHidden = true
                                self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#5E7E47")
                                self.comingUpView.isHidden = false
                                self.swipeLabel.text = ">>> SWIPE TO ANSWER >>>"
                                self.messageLabel.text = res["message"] as? String
                            }
                        }
                    } else {
                        // show coming up view
                        self.shadowView.isHidden = true
                        self.comingUpView.isHidden = false
                        self.swipeLabel.text = ">>> DO NOT SWIPE !! >>>"
                        self.messageLabel.text = res["message"] as? String
                        self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#FF0000")
                    }
                }
            } else {
                print("Error")
            }
        }
    }
    
    // MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            let product: Product!
            product = productList[indexPath.row]
            cell.configureCell(product: product)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    
    @IBAction func sideMenuPressed(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func updatePriceLabel() {
        var price = 0
        for item in productList {
            price += Int(item.price!)!
        }
        self.totalWorthLabel.text = "Worth Rs.\(price)/-"
    }

    
}
