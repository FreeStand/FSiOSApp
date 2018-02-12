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

    var brandList = [Brand]()
    var couponList = [Coupon]()
    var selectedBrand: Brand!
    var quesArray: NSArray!
    var couponCode: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            
            if coupon.redeem == nil {
                // Hit APIEndpopints
                cell.activityIndicator.startAnimating()
                Alamofire.request("\(APIEndpoints.couponSurveyEndpoint)&brand=\(coupon.brandName)&couponID=\(coupon.couponID)").responseJSON(completionHandler: { (res) in
                    if let response = res.result.value as? NSDictionary {
                        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                        feedbackVC?.couponCode = response["couponCode"] as? String
                        feedbackVC?.quesArray = response["questions"] as? NSArray
                        feedbackVC?.sender = FeedbackSender.couponVC
                        feedbackVC?.surveyID = coupon.couponID
                        feedbackVC?.brand = coupon.brandName
                        cell.activityIndicator.stopAnimating()
                        self.navigationController?.pushViewController(feedbackVC!, animated: true)
                    } else {
                        print("Error: Can't cast couponOnClick resp as dict")
                    }
                })
         
            } else {
                cell.showCopyView()
                UIPasteboard.general.string = coupon.redeem
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func sideMenuPressed(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }


}
