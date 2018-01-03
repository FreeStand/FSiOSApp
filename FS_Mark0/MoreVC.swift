//
//  MoreVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 30/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import FBSDKLoginKit

class MoreVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNotif), name: Notification.Name("GoogleSignInVCNotification"), object: nil)
        
    }
    
    @objc func dismissNotif() {
        performSegue(withIdentifier: "moreToInvite", sender: nil)
        UserDefaults.standard.set("true", forKey: "isGoogleSignedIn")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            performSegue(withIdentifier: "moreToProfile", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "moreToOrders", sender: nil)
            break
        case 3:
            performSegue(withIdentifier: "moreToFAQs", sender: nil)
            break
        
        case 4:
            var nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
            let version = nsObject as! String
            nsObject = Bundle.main.infoDictionary!["CFBundleVersion"]
            let build = nsObject as! String
            
            if let url = URL(string: "mailto:aryan@freestand.in?subject=issue%20raised%20[iOS]&body=App%20version:%20\(version)%20(\(build))") {
                UIApplication.shared.open(url)
            }
            break
        case 5:
            logOut()
            break
        default:
            break
        }
    }

    func logOut() {
        print("Log Out Btn Pressed")
        KeychainWrapper.standard.removeObject(forKey: "KEY_UID")
        try! Auth.auth().signOut()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UIApplication.shared.delegate?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SIgnInVC")
    }
    
}
