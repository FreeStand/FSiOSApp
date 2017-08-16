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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(infoBtnPressed), name: Notification.Name("myNotification"), object: nil)
    }


    func infoBtnPressed() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath)
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5.0
        
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0).cgColor
        cell.contentView.addTopBorderWithColor(color: UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0), width: 8.0)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
