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
        self.navigationController?.navigationBar.tintColor = UIColor.black

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
        DataService.ds.REF_SAMPLES.child(key).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                print(dict)
                let order = Order()

                order.campaignID = dict["campaignID"] as? String
                order.partnerID = dict["partnerID"] as? String
                order.time = dict["time"] as? String
                order.uID = dict["uID"] as? String
                
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

            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5.0
            
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0).cgColor
            cell.contentView.addTopBorderWithColor(color: UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0), width: 8.0)
            cell.contentView.addLeftBorderWithColor(color: UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0), width: 8.0)
            cell.contentView.addRightBorderWithColor(color: UIColor().HexToColor(hexString: "#E2E8F4", alpha: 1.0), width: 8.0)
            
            let order: Order!
            order = orderList[indexPath.row]
            cell.configureCell(order: order)
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 276
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
