//
//  NewCouponVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 07/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class NewCouponVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var brandImg: UIImageView!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var brand: Brand!
    var brandName: String!
    var surveyID: String!
    var couponList = [Coupon]()
    var selectedCouponCode: String!
    var coupons: [String:[String:Any]]!
    var feedbackQuestionsDict: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        brandImg.downloadedFrom(link: brand.imgUrl!)
        brandLbl.text = brand.name
        brandName = brand.name
        coupons = brand.coupons
        tableView.dataSource = self
        tableView.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(infoBtnPressed), name: Notification.Name("myNotification"), object: nil)

        self.navigationItem.title = brand.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        self.tableView.tableFooterView = UIView()
        brandImg.addTopBorderWithColor(color: UIColor.white, width: 1)
        navigationController?.navigationBar.titleTextAttributes = attrs
        parseCoupons()
    }

    @objc func infoBtnPressed() {
        print("Notification Received")
        
        if infoView.isHidden == true {
            view.bringSubview(toFront: infoView)
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.infoView.isHidden = false
            }, completion: nil)
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        if infoView.isHidden == false {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.infoView.isHidden = true
            }, completion: nil)
            view.sendSubview(toBack: infoView)
        }
    }
    
    func parseCoupons() {
        for (key ,dict) in coupons {
            let coupon = Coupon()
            coupon.couponID = key
            if let title = dict["title"] as? String {
                coupon.title = title
            }
            if let subtitle = dict["subtitle"] as? String {
                coupon.subtitle = subtitle
            }
            if let redeemURL = dict["redeemURL"] as? String {
                coupon.redirectURL = redeemURL
            }
            if let imgURL = dict["imgURL"] as? String {
                coupon.imgURL = imgURL
            }
            if let isDigital = dict["isDigital"] as? Bool {
                coupon.isDigital = isDigital
            }
            
            if let isCouponUnique = dict["isCouponUnique"] as? Bool {
                coupon.isCouponUnique = isCouponUnique
            }
            
            if let couponCode = dict["couponCode"] as? String {
                coupon.couponCode = couponCode
            }
            
            self.couponList.append(coupon)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let coupon = couponList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if coupon.isCouponUnique! {
            let url = "\(APIEndpoints.couponEndpoint)?uid=\(UserInfo.uid!)&brand=\(brand.name!)&couponID=\(coupon.couponID!)"
            self.surveyID = "\(brand.name!)_\(coupon.couponID!)"
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                if let responseDict = response.result.value as? NSDictionary {
                    print("Coupons: \(responseDict)")
                    if let containsFeedback = responseDict["containsFeedBack"] as? Bool {
                        if containsFeedback == true {
                            // show feedback survey
                            if let couponCode = responseDict["couponCode"] as? String {
                                // pass coupon code to next VC
                                self.selectedCouponCode = couponCode
                            } else {
                                print("Can't cast couponCode")
                            }
                            if let questionDict = responseDict["questions"] as? NSDictionary {
                                self.feedbackQuestionsDict = questionDict
                            } else {
                                print("Can't cast questionDict")
                            }
                            // perform segue to feedback
                            
                            let FeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                            FeedbackVC?.quesDict = self.feedbackQuestionsDict
                            FeedbackVC?.surveyID = self.surveyID
                            FeedbackVC?.sender = "Coupon"
                            FeedbackVC?.couponCode = self.selectedCouponCode
                            self.navigationController?.pushViewController(FeedbackVC!, animated: true)
                            
//                            self.performSegue(withIdentifier: "couponToFeedback", sender: nil)
                            print("Coupon: segue to feedback")
                            
                        } else {
                            // show couponCode
                            if let couponCode = responseDict["couponCode"] as? String {
                                // pass coupon code to next VC
                                self.selectedCouponCode = couponCode
                                print("Coupon: segue to coupon code  \(couponCode)")
                                self.performSegue(withIdentifier: "couponToDetail", sender: nil)
                            }
                        }
                    } else {
                        print("Coupons: Can't cast containsFeedback")
                    }
                } else {
                    print("Coupons: Can't cast responseDict")
                }
            })

        } else {
            selectedCouponCode = coupon.couponCode
            self.performSegue(withIdentifier: "couponToDetail", sender: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as? CouponCell {
            cell.contentView.addBottomBorderWithColor(color: UIColor().HexToColor(hexString: "#111218", alpha: 1.0), width: 2.0)
            cell.clipsToBounds = true

            let coupon: Coupon!
            coupon = couponList[indexPath.row]
            cell.configureCell(coupon: coupon)
            cell.layoutIfNeeded()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue")
        
        if segue.identifier == "couponToDetail" {
            if let vc = segue.destination as? CouponDigitalVC {
                vc.couponCode = selectedCouponCode
            }
        }
        
        if segue.identifier == "couponToFeedback" {
            if let vc = segue.destination as? CouponFeedbackOnlineVC {
//                vc.surveyID = "\(self.brand.name)"
                vc.quesDict = self.feedbackQuestionsDict
                vc.couponCode = selectedCouponCode
            }
        }
    }
    
}
