//
//  OrderTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 19/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class OrderTVC: UITableViewController {

    var orderList = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Orders"
        
        getOrders()
    }
    
    func getOrders() {
        Alamofire.request(APIEndpoints.getOrdersEndpoint).responseJSON { (res) in
            if let response = res.result.value as? NSDictionary {
                if response["isEmpty"] as? Bool == false {
                    let array = response["orders"] as? [[String:String]]
                    for anOrder in array! {
                        let order = Order()
                        order.campaignID = anOrder["campaignID"]
                        self.orderList.append(order)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
