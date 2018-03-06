//
//  BrandsTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAnalytics
import SVProgressHUD

class BrandsTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var brandList = [Brand]()
    var couponList = [Coupon]()
    var selectedBrand: Brand!
    var quesArray: [APIService.Question]!
    var couponCode: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Coupons")
        Analytics.logEvent(Events.SCREEN_COUPON, parameters: nil)
        let sideMenuNC = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideMenuNC
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.35
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.90
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.fiBlack
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        SideMenuManager.default.menuWidth = 220
        SideMenuManager.default.menuAllowPushOfSameClassTwice = false

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCoupons()
    }
    
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        showCoupons()
        refreshControl.endRefreshing()
    }

    
    func showCoupons() {
        SVProgressHUD.show()
        APIService.shared.fetchCoupons { (coupons) in
            SVProgressHUD.dismiss()
            self.couponList = coupons
            self.tableView.reloadData()
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
            
            if coupon.redeem == nil {
                Analytics.logEvent(Events.COUPON_SEL, parameters: nil)
                // Hit APIEndpopints
                SVProgressHUD.show()
                
                APIService.shared.couponSurvey(brand: coupon.brandName, couponID: coupon.couponID, completionHandler: { (response) in
                    let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                    feedbackVC?.couponCode = response.couponCode
                    feedbackVC?.quesArray = response.questions
                    feedbackVC?.sender = FeedbackSender.couponVC
                    feedbackVC?.surveyID = coupon.couponID
                    feedbackVC?.brand = coupon.brandName
                    SVProgressHUD.dismiss()
                    self.navigationController?.pushViewController(feedbackVC!, animated: true)

                })
            } else {
                Analytics.logEvent(Events.COUPON_COPIED, parameters: nil)
                cell.showCopyView()
                UIPasteboard.general.string = coupon.redeem
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func sideMenuPressed(_ sender: Any) {
        Analytics.logEvent(Events.SIDEBAR_TAPPED, parameters: nil)
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }


}
