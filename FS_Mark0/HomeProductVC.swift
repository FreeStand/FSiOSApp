//
//  HomeProductVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 11/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAnalytics
import SwiftyJSON
import SAConfettiView

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
    
    var confettiView: SAConfettiView!
    var productList = [Product]()
    var surveyID: String!
    var quesArray: [APIService.Question]!
    var sender: String!
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        confettiView = SAConfettiView(frame: comingUpView.bounds)

        Analytics.logEvent(Events.SCREEN_HOME, parameters: nil)
        
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
        
        confettiView.type = .Confetti
        self.comingUpView.addSubview(confettiView)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.catchIt), name: NSNotification.Name(rawValue: "myNotif"), object: nil)
    }
    
    @objc func catchIt(_ userInfo: Notification){
        print("Catch It")
        print(userInfo)
        let notif = JSON(userInfo.object!)
        if let _ = notif["url"].string {
            let url = notif["url"].string?.replacingOccurrences(of: "\"" , with: "")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as? WebVC
            vc?.url = url
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
//        getProducts()
        getHome()

        let prefs:UserDefaults = UserDefaults.standard
        if prefs.value(forKey: "startUpNotif") != nil{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotif"), object: prefs.value(forKey: "startUpNotif"))
            prefs.removeObject(forKey: "startUpNotif")
            prefs.synchronize()
        }
    }
    
    
    @objc func buttonRight () {
        if self.quesArray != nil && self.surveyID != nil {
            if self.sender == FeedbackSender.preSampling {
                Analytics.logEvent(Events.HOME_SWIPE_COLLECT, parameters: nil)
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
                Analytics.logEvent(Events.HOME_SWIPE_ANSWER, parameters: nil)
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
                        self.swipeLabel.text = ">>> SWIPE TO ANSWER !! >>>"
                    })
                })
            }
        } else {
            Analytics.logEvent(Events.HOME_SWIPE_DO_NOT, parameters: nil)
            self.swipeLabel.text = "HAHAHAHAHAHA"
            self.swipeView.backgroundColor = UIColor.fiYellow
            confettiView.type = SAConfettiView.ConfettiType.Diamond
            i += 1
            switch i%4 {
                case 0:
                    confettiView.stopConfetti()
                    confettiView.type = SAConfettiView.ConfettiType.Diamond
                    confettiView.startConfetti()
                case 1:
                    confettiView.stopConfetti()
                    confettiView.type = SAConfettiView.ConfettiType.Star
                    confettiView.startConfetti()
                case 2:
                    confettiView.stopConfetti()
                    confettiView.type = SAConfettiView.ConfettiType.Triangle
                    confettiView.startConfetti()
                case 3:
                    confettiView.stopConfetti()
                    confettiView.type = SAConfettiView.ConfettiType.Confetti
                    confettiView.startConfetti()
            default:
                break
            }
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.swipeLabel.text = ">>> DO NOT SWIPE !! >>>"
                self.swipeView.backgroundColor = UIColor.red
            })
        }
    }
    
    func getHome() {
        self.swipeLabel.text = "LOADING..."
        self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#5B86FF")
        APIService.shared.fetchHomeScreenData { (homeScreenResult) in
            if !homeScreenResult.isEmpty! {
                if homeScreenResult.surveyType == "pre" {
                    self.productList = (homeScreenResult.survey?.products)!
                    self.tableView.reloadData()
                    self.surveyID = nil
                    self.surveyID = homeScreenResult.survey?.surveyID
                    self.quesArray = nil
                    self.quesArray = homeScreenResult.survey?.questions
                    self.sender = FeedbackSender.preSampling
                    self.swipeLabel.text = ">>> SWIPE TO COLLECT !! >>>"
                    self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#5B86FF")
                    self.shadowView.isHidden = false
                    self.comingUpView.isHidden = true

                } else if homeScreenResult.surveyType == "post" {
                    self.surveyID = nil
                    self.quesArray = nil
                    self.quesArray = homeScreenResult.survey?.questions
                    self.surveyID = homeScreenResult.survey?.surveyID
                    self.sender = FeedbackSender.postSampling
                    self.shadowView.isHidden = true
                    self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#5E7E47")
                    self.comingUpView.isHidden = false
                    self.swipeLabel.text = ">>> SWIPE TO ANSWER >>>"
                    self.messageLabel.text = homeScreenResult.message

                }
            } else {
                self.confettiView.startConfetti()
                self.shadowView.isHidden = true
                self.comingUpView.isHidden = false
                self.swipeLabel.text = ">>> DO NOT SWIPE !! >>>"
                self.messageLabel.text = homeScreenResult.message
                self.swipeView.backgroundColor = UIColor().HexToColor(hexString: "#FF0000")

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Analytics.logEvent(Events.HOME_PRODUCT_TAPPED, parameters: nil)
    }
    
    
    @IBAction func sideMenuPressed(_ sender: Any) {
        Analytics.logEvent(Events.SIDEBAR_TAPPED, parameters: nil)
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
