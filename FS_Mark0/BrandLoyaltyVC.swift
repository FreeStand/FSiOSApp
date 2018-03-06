//
//  BrandLoyaltyVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 16/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD

class BrandLoyaltyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var brandImgView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var consumptionLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var brandImgHeightConstraint: NSLayoutConstraint!
    var defaultOffSet: CGPoint?
    var defOff: CGPoint!
    var brandImgURL: String!
    var loyaltyCouponList = [LoyaltyCoupon]()
    
    override func viewDidAppear(_ animated: Bool) {
        defaultOffSet = tableView.contentOffset
        defOff = tableView.contentOffset
        getLoyaltyCoupons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Kadak Loyalty"
        brandImgView.backgroundColor = UIColor.fiBlack
        tableView.delegate = self
        tableView.dataSource = self
        infoView.dropShadow(scale: true)
    }
    
    func getLoyaltyCoupons() {
        SVProgressHUD.show()
        APIService.shared.fetchLoyaltyCoupon(brand: "Kadak") { (response) in
            self.brandImgView.downloadedFrom(link: response.brandImgURL)
            self.loyaltyCouponList = response.couponList!
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
        
    }

    //  MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loyaltyCouponList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyCell", for: indexPath) as? LoyaltyCell {
            let loyaltyCoupon: LoyaltyCoupon!
            loyaltyCoupon = loyaltyCouponList[indexPath.row]
            cell.configureCell(loyaltyCoupon: loyaltyCoupon)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coupon = loyaltyCouponList[indexPath.row]
        if coupon.unlockable! {
            if !coupon.redeem! {
                
                print("Loyalty: Clickable")
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Enter Your FreeStand Code", message: "Enter the code here to Level Up!!", preferredStyle: .alert)
                
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter Code Here"
                }
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    DataService.ds.REF_USER_CURRENT.child("loyalty").child("Kadak").updateChildValues([coupon.couponID!:true])
                    self.getLoyaltyCoupons()
                    print("Text field: \(String(describing: textField?.text))")
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }

        } else {
            print("Loyalty: UnClickable")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
}
