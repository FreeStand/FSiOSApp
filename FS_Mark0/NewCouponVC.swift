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
    var couponList = [Coupon]()
    var selectedCouponCode: String!
    var coupons: [String:[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        brandImg.downloadedFrom(link: brand.imgUrl!)
        brandLbl.text = brand.name
        brandName = brand.name
        coupons = brand.coupons
        tableView.dataSource = self
        tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(infoBtnPressed), name: Notification.Name("myNotification"), object: nil)

        self.navigationItem.title = brand.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        self.tableView.tableFooterView = UIView()

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
        for (_ ,dict) in coupons {
            let coupon = Coupon()
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
                if isCouponUnique {
                    if let Coupon = UserDefaults.standard.string(forKey: "\(self.brand.name!)Coupon") {
                        print("here")
                        coupon.couponCode = Coupon
                    } else {
                        print("here now")
                        let url = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/\(coupon.redirectURL!)"
                        print(url)
                        Alamofire.request(url).responseJSON { response in
                            if let json = response.result.value as? NSDictionary {
                                if let code = json["firstCoupon"] as? String {
                                    coupon.couponCode = code
                                    UserDefaults.standard.set(code, forKey: "\(self.brand.name!)Coupon")
                                    DataService.ds.updateFirebaseDBUserWithUserData(userData: [["\(self.brand.name!)Coupon": code as AnyObject]])
                                }
                            }
                        }
                    }
                } else {
                    if let couponCode = dict["couponCode"] as? String {
                        coupon.couponCode = couponCode
                    }

                }
            }
            
            self.couponList.append(coupon)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func handleUniqueCoupon() {
        var request = URLRequest(url: URL(string: "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getOlaCoupons")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            }.resume()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let coupon = couponList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        if let feed = UserDefaults.standard.string(forKey: "\(brand.name!)fb") {
            if feed == "true" {
                selectedCouponCode = coupon.couponCode
                performSegue(withIdentifier: "couponToDetail", sender: nil)
            }
        } else {
            if coupon.isDigital == true {
                selectedCouponCode = coupon.couponCode
                print("digital")
                makeSegue()
            } else {
                selectedCouponCode = coupon.couponCode
                print("offline")
                makeSegue()
            }
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
            cell.contentView.addBottomBorderWithColor(color: UIColor().HexToColor(hexString: "#393939", alpha: 1.0), width: 8.0)
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
    
    func makeDigitalSegue() {
        self.performSegue(withIdentifier: "couponToDigitalDetail", sender: nil)
    }
    
    func makeSegue() {
        self.performSegue(withIdentifier: "couponToFeedBack", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue")
        
        if segue.identifier == "couponToDigitalDetail" {
            if let vc = segue.destination as? CouponDigitalVC {
                vc.couponCode = selectedCouponCode
            }
        }
        
        if segue.identifier == "couponToDetail" {
            if let vc = segue.destination as? CouponDigitalVC {
                vc.couponCode = selectedCouponCode
            }
        }
        
        if segue.identifier == "couponToFeedBack" {
            if let vc = segue.destination as? CouponFeedbackOnlineVC {
                vc.brand = self.brand
                vc.couponCode = selectedCouponCode
            }
        }
    }
    
}
