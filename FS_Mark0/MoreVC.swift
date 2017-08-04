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
        
        self.tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            performSegue(withIdentifier: "moreToSettings", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "moreToProfile", sender: nil)
            break
        case 3:
            performSegue(withIdentifier: "moreToHistory", sender: nil)
            break
        case 4:
            performSegue(withIdentifier: "moreToSupport", sender: nil)
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
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if let vc = segue.destination as? ProfileVC {
//            let backItem = UIBarButtonItem()
//            backItem.title = "Back"
//            navigationItem.backBarButtonItem = backItem
//            navigationItem.title = "Profile"
//        }
        
    }

}
