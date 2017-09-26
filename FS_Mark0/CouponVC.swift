//
//  CouponVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 27/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class CouponVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var brandImg: UIImageView!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var infoView: UIView!

    
    var brand: Brand!
    var couponList = [Coupon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandImg.downloadedFrom(link: brand.imgUrl!)
        brandLbl.text = brand.name
        tableView.dataSource = self
        tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(infoBtnPressed), name: Notification.Name("myNotification"), object: nil)
        getCoupons()
        
        self.navigationItem.title = brand.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs

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
    
    func getCoupons() {
        DataService.ds.REF_BRANDS.child(brand.name!).child("coupons").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let coupon = Coupon()
                
                if let title = dict["title"] as? String {
                    coupon.title = title
                } else {
                    print("Error: Can't find/cast title in the coupon.")
                }
                
                if let subtitle = dict["subtitle"] as? String {
                    coupon.subtitle = subtitle
                } else {
                    print("Error: Can't find/cast subtitle in the coupon.")
                }
                
                if let imgURL = dict["imgURL"] as? String {
                    coupon.imgURL = imgURL
                } else {
                    print("Error: Can't find/cast imgURL in the coupon.")
                }
                
                if let redirectURL = dict["redeemURL"] as? String {
                    coupon.redirectURL = redirectURL
                } else {
                    print("Error: Can't find/cast redirectURL in the coupon.")
                }
                
                self.couponList.append(coupon)
                DispatchQueue.main.async {
                    print("reload")
                    self.tableView.reloadData()
                }
            } else {
                print("Error: Can't cast dict in brand")
            }
        }) { (error) in
            print("Error: Can't load Brands from Brands DB")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return couponList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as? CouponCell {
            
            let coupon: Coupon!
            coupon = couponList[indexPath.row]
            cell.configureCell(coupon: coupon)
            cell.redeemBtn.addTarget(self, action: #selector(makeSegue), for: .touchUpInside)

            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func makeSegue(button:UIButton) {
        performSegue(withIdentifier: "couponsToWebView", sender: button)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "couponsToWebView" {
            if let vc = segue.destination as? WebViewVC {
                if let button = sender as? UIButton {
                    let cell = button.superview?.superview as! CouponCell
                    vc.url = NSURL(string: cell.redirectURL)! as URL
                } else {
                    print("Error: Can't cast button in prepareForSegue")
                }
                
            }
        }
    }
}
