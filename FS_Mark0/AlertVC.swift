//
//  AlertVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 01/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class AlertVC: UITableViewController {
    
    var alertList = [Alert]()

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationIconBadgeNumber = 0

        self.tableView.tableFooterView = UIView()
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs

        getAlertsFromNotificationDB()
    }
    
    func getAlertsFromNotificationDB() {
        DataService.ds.REF_NOTIFICATIONS.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let alert = Alert()
                if let title = dict["title"] as? String {
                    alert.title = title
                } else {
                    print("Error: Can't cast title in Alert")
                }
                if let body = dict["body"] as? String {
                    alert.body = body
                } else {
                    print("Error: Can't cast body in Alert")
                }
                if let date = dict["date"] as? String {
                    alert.time = date
                } else {
                    print("Error: Can't cast time in Alert")
                }
                
                self.alertList.append(alert)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                print("Error: Can't cast notification")
            }
        }) { (error) in
            print("Error loading Alerts: \(error.localizedDescription)")
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as? AlertCell {
            
            let alert: Alert!
            alert = alertList[indexPath.row]
            cell.configureCell(alert: alert)
            
            return cell
        }


        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }

 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? WebViewVC {
//            vc.url = NSURL(string: "https://google.com")! as URL
//        }
    
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//    }

}
