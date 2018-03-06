//
//  AlertVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 01/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD
import SideMenu
import FirebaseAnalytics

class AlertVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    
    var alertList = [Alert]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(Events.SCREEN_ALERTS, parameters: nil)
        
        let sideMenuNC = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideMenuNC
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.35
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.90
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.fiBlack
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        SideMenuManager.default.menuWidth = 220

        
        let rc = UIRefreshControl()
        tableView.refreshControl = rc
        
        rc.addTarget(self, action: #selector(refresh(refreshControl:)), for: UIControlEvents.valueChanged)

        
        tableView.delegate = self
        tableView.dataSource = self
        UIApplication.shared.applicationIconBadgeNumber = 0

        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = "Alerts"
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs

        getAlerts()
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        getAlerts()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    
    func getAlerts() {
        SVProgressHUD.show()
        APIService.shared.fetchAlerts { (alertList) in
            self.alertList = alertList
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }

    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as? AlertCell {
            
            let alert: Alert!
            alert = alertList[indexPath.row]
            cell.configureCell(alert: alert)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    @IBAction func sideMenuPressed(_ sender: Any) {
        Analytics.logEvent(Events.SIDEBAR_TAPPED, parameters: nil)
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Analytics.logEvent(Events.ALERT_TAPPED, parameters: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
