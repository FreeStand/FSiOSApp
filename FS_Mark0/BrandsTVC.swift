//
//  BrandsTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu


class BrandsTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImg: UIImageView!

    var brandList = [Brand]()
    var couponList = [Coupon]()
    var selectedBrand: Brand!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImg.clipsToBounds = true
        
        let sideMenuNC = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideMenuNC
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.35
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.90
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.fiBlack
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
        SideMenuManager.defaultManager.menuAllowPushOfSameClassTwice = false

        let rc = UIRefreshControl()
        tableView.refreshControl = rc
        
        rc.addTarget(self, action: #selector(refresh(refreshControl:)), for: UIControlEvents.valueChanged)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        self.navigationItem.title = "Coupons"
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        self.tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "Doodle-Login.png"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showCoupons()
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        showCoupons()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    
    func showCoupons() {
        let url = "\(APIEndpoints.showCouponsEndpoint)?uid=\(UserInfo.uid!)"
        print(url)
        Alamofire.request(url).responseJSON { (res) in
            self.couponList.removeAll()
            
            guard let data = res.data else { return }
            do {
                let coupons = try JSONDecoder().decode([Coupon].self, from: data)
                self.couponList = coupons
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
    


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return couponList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as? CouponCell {
            
            cell.clipsToBounds = true
            let coupon: Coupon!
            coupon = couponList[indexPath.row]
            cell.configureCell(coupon: coupon)
            
            return cell
        }
        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CouponCell {
            let coupon = couponList[indexPath.row]
            
            if coupon.showCouponOnScreen == nil {
                // Hit APIEndpopints
                
                cell.activityIndicator.startAnimating()

                if coupon.generalCouponCode != nil {
                    let url = "\(APIEndpoints.generalCouponEndpoint)?uid=\(UserInfo.uid!)&brand=\(coupon.brandName)&couponID=\(coupon.couponID)"
                    Alamofire.request(url).responseJSON(completionHandler: { (response) in
                        if let dict = response.result.value as? NSDictionary {
                            if let containsFeedBack = dict["containsFeedBack"] as? Bool {
                                if containsFeedBack {
                                    let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                                    feedbackVC?.couponCode = coupon.generalCouponCode
                                    feedbackVC?.quesArray = dict["questions"] as? NSArray
                                    feedbackVC?.sender = FeedbackSender.couponVC
                                    feedbackVC?.surveyID = coupon.couponID
                                    cell.activityIndicator.stopAnimating()
                                    self.navigationController?.pushViewController(feedbackVC!, animated: true)
                                    
                                } else {
                                    // no feedback
                                    // show coupon
                                    let couponDigitalVC = self.storyboard?.instantiateViewController(withIdentifier: "CouponDigitalVC") as? CouponDigitalVC
                                    couponDigitalVC?.couponCode = coupon.generalCouponCode
                                    cell.activityIndicator.stopAnimating()
                                    self.navigationController?.pushViewController(couponDigitalVC!, animated: true)
                                    
                                }
                            } else {
                                print("Can't cast containsFeedBack in generalCoupon")
                            }
                        } else {
                            print("Can't cast dict in generalCoupon")
                        }
                    })
                    
                } else {
                    let url = "\(APIEndpoints.couponEndpoint)?uid=\(UserInfo.uid!)&brand=\(coupon.brandName)&couponID=\(coupon.couponID)"
                    Alamofire.request(url).responseJSON { (response) in
                        if let dict = response.result.value as? NSDictionary {
                            if let containsFeedBack = dict["containsFeedBack"] as? Bool {
                                if !containsFeedBack {
                                    //does not contain feedback
                                    //show couponcode directly
                                    let couponDigitalVC = self.storyboard?.instantiateViewController(withIdentifier: "CouponDigitalVC") as? CouponDigitalVC
                                    couponDigitalVC?.couponCode = dict["couponCode"] as? String
                                    cell.activityIndicator.stopAnimating()
                                    self.navigationController?.pushViewController(couponDigitalVC!, animated: true)
                                } else {
                                    //contains feedback
                                    //show feedback
                                    //then couponCode
                                    let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                                    feedbackVC?.couponCode = dict["couponCode"] as? String
                                    feedbackVC?.quesArray = dict["questions"] as? NSArray
                                    feedbackVC?.sender = FeedbackSender.couponVC
                                    feedbackVC?.surveyID = coupon.couponID
                                    cell.activityIndicator.stopAnimating()
                                    self.navigationController?.pushViewController(feedbackVC!, animated: true)
                                }
                            }
                        }
                    }
                }
         
            } else {
                // Coupon code displayed
                // Copy Coupon Code
                cell.showCopyView()
                UIPasteboard.general.string = coupon.showCouponOnScreen
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func sideMenuPressed(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }


}
