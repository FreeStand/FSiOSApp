//
//  CouponVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 04/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class CouponVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    
    var couponList = [Coupon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(infoBtnPressed), name: Notification.Name("myNotification"), object: nil)
        getCoupons()
    }
    
    func getCoupons() {
        DataService.ds.REF_COUPONS.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let coupon = Coupon()
                    print(dict)
                if let title = dict["title"] as? String {
                    coupon.title = title
                } else {
                    print("Error: Can't retrieve coupon title")
                }
                if let subtitle = dict["subtitle"] as? String {
                    coupon.subtitle = subtitle
                } else {
                    print("Error: Can't retrieve coupon subtitle")
                }
                if let redirectURL = dict["redirectURL"] as? String {
                    coupon.redirectURL = redirectURL
                } else {
                    print("Error: Can't retrieve coupon redirectURL")
                }
                self.couponList.append(coupon)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error: Can't cast dict from snapshot in getCoupons")
            }

        }) { (error) in
            print("Error: Can't load Coupons from Coupons DB")
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as? CouponCell {
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5.0
            
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0).cgColor
            cell.contentView.addTopBorderWithColor(color: UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0), width: 8.0)
            
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell")
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
