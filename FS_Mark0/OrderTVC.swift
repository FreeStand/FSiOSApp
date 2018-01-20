//
//  OrderTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 19/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class OrderTVC: UITableViewController {

    var orderList = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Orders"
        self.navigationController?.navigationBar.tintColor = UIColor.white

        getSamplesFromUserDB()
    }
    
    func getSamplesFromUserDB() {
        DataService.ds.REF_USER_CURRENT.child("samples").observe(.childAdded, with: { (snapshot) in
            self.getSamplesInfoFromSamplesDB(key: snapshot.key)
        }) { (error) in
            print("Error: Can't load samples from users DB.")
        }
    }
    
    func getSamplesInfoFromSamplesDB(key: String) {
        DataService.ds.REF_COLLEGES.child(key).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let order = Order()

                if let campaignID = dict["campaignID"] as? String {
                    order.campaignID = campaignID
                } else {
                    print("Error: Can't retrieve CampaignID")
                }
                if let partnerID = dict["partnerID"] as? String {
                    order.partnerID = partnerID
                } else {
                    print("Error: Can't retrieve partnerID")
                }


                self.orderList.append(order)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error: Can't cast dict from snapshot in getSamplesInfoFromSamplesDB")
            }

        }) { (error) in
            print("Error: Can't load samples from Samples DB")
        }
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? OrderCell{
            
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor().HexToColor(hexString: "#393939", alpha: 1.0).cgColor

            let order: Order!
            order = orderList[indexPath.row]
            cell.configureCell(order: order)
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
