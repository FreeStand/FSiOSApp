//
//  BrandsTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class BrandsTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var brandList = [Brand]()
    var couponList = [Coupon]()
    var selectedBrand: Brand!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func showCoupons() {
        let url = "\(APIEndpoints.showCouponsEndpoint)?uid=\(UserInfo.uid!)"
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let couponsDict = response.result.value as? [String:[String:String]] {
                self.couponList.removeAll()
                for (couponID, dict) in couponsDict {
                    let coupon = Coupon()
                    coupon.couponID = couponID
                    if let imgURL = dict["imgURL"] {
                        coupon.imgURL = imgURL
                    } else {
                        print("Error: Can't cast imgURL in coupon")
                    }
                    
                    if let title = dict["title"] {
                        coupon.title = title
                    } else {
                        print("Error: Can't cast title in coupon")
                    }
                    
                    if let subtitle = dict["subtitle"] {
                        coupon.subtitle = subtitle
                    } else {
                        print("Error: Can't cast subtitle in coupon")
                    }
                    
                    if let brandName = dict["brandName"] {
                        coupon.brandName = brandName
                    } else {
                        print("Error: Can't cast brandName in coupon")
                    }
                    
                    if let generalCouponCode = dict["generalCouponCode"] {
                        coupon.generalCouponCode = generalCouponCode
                    } else {
                        print("Error: Can't cast generalCouponCode in coupon")
                    }
                    
                    if let showCouponOnScreen = dict["showCouponOnScreen"] {
                        coupon.showCouponOnScreen = showCouponOnScreen
                    } else {
                        print("Error: Can't cast showCouponOnScreen in coupon")
                    }
                    
                    self.couponList.append(coupon)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            } else {
                print("Error: Can't cast couponsDict in BrandsTVC")
            }
        }
    }
    
    func getCoupons() {
        DataService.ds.REF_COUPONS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let coupon = Coupon()
                coupon.couponID = snapshot.key
                if let imgURL = dict["imgURL"] as? String {
                    coupon.imgURL = imgURL
                } else {
                    print("Error: Can't cast imgURL in coupon")
                }
                
                if let title = dict["title"] as? String {
                    coupon.title = title
                } else {
                    print("Error: Can't cast title in coupon")
                }
                
                if let subtitle = dict["subtitle"] as? String {
                    coupon.subtitle = subtitle
                } else {
                    print("Error: Can't cast subtitle in coupon")
                }
                
                if let brandName = dict["brandName"] as? String {
                    coupon.brandName = brandName
                } else {
                    print("Error: Can't cast brandName in coupon")
                }
                
                if let generalCouponCode = dict["generalCouponCode"] as? String {
                    coupon.generalCouponCode = generalCouponCode
                } else {
                    print("Error: Can't cast generalCouponCode in coupon")
                }

                
                self.couponList.append(coupon)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Can't cast dict in Coupons")
            }
        }
    }

    func getBrands() {
        print("called")
        DataService.ds.REF_BRANDS.observe(.childAdded, with:  { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let brand = Brand()
                brand.name = snapshot.key
                
                if let imgURL = dict["imgURL"] as? String {
                    brand.imgUrl = imgURL
                } else {
                    print("Error: Can't find/cast URL in \(brand.name ?? "Brand")")
                }
                
                if let questions = dict["questions"] as? NSDictionary {
                    brand.questions = questions
                } else {
                    print("Error: Can't find/cast questions in \(brand.name ?? "Brand")")
                }
                
                if let coupons = dict["coupons"] as? [String: [String: Any]] {
                    brand.coupons = coupons
                    brand.totalDeals = coupons.count
                } else {
                    brand.totalDeals = 0
                    print("Error: Can't find/cast coupons in \(brand.name ?? "Brand")")
                }
                
                if brand.totalDeals != 0 {
                    self.brandList.append(brand)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                
            } else {
                print("Error: Can't cast dict from snapshot in Brands")
            }
        }) { (error) in
            print("Error: Can't load Brands from Brands DB")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    let url = "\(APIEndpoints.generalCouponEndpoint)?uid=\(UserInfo.uid!)&brand=\(coupon.brandName!)&couponID=\(coupon.couponID!)"
                    Alamofire.request(url).responseJSON(completionHandler: { (response) in
                        if let dict = response.result.value as? NSDictionary {
                            if let containsFeedBack = dict["containsFeedBack"] as? Bool {
                                if containsFeedBack {
                                    let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
                                    feedbackVC?.couponCode = coupon.generalCouponCode
                                    feedbackVC?.quesArray = dict["questions"] as? NSArray
                                    feedbackVC?.sender = "Coupon"
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
                    let url = "\(APIEndpoints.couponEndpoint)?uid=\(UserInfo.uid!)&brand=\(coupon.brandName!)&couponID=\(coupon.couponID!)"
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
                                    feedbackVC?.sender = "Coupon"
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BrandToCoupon" {
            if let vc = segue.destination as? NewCouponVC {
                vc.brand = self.selectedBrand
            }
        }
    }
    

}
