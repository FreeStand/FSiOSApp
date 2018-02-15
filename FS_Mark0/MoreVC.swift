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
import FirebaseAnalytics

class MoreVC: UITableViewController {
    
    private weak var screenshot: UIView?
    @IBOutlet weak var profImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!

    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let screenshot = presentingViewController?.view.snapshotView(afterScreenUpdates: false) {
            presentingViewController?.view.addSubview(screenshot)
            self.screenshot = screenshot
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        screenshot?.removeFromSuperview()
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(Events.SCREEN_MORE, parameters: nil)
        nameLbl.text = Auth.auth().currentUser?.displayName!
        emailLbl.text = Auth.auth().currentUser?.email!

        let imageData = UserDefaults.standard.object(forKey: "profImageData") as! NSData
        profImgView.maskCircle(anyImage: UIImage(data: imageData as Data)!)

        
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
            Analytics.logEvent(Events.ORDERS_TAPPED, parameters: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTVC") as? OrderTVC
            self.navigationController?.pushViewController(vc!, animated: true)
            break
        case 2:
            Analytics.logEvent(Events.ADDRESS_TAPPED, parameters: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressTVC") as? AddressTVC
            self.navigationController?.pushViewController(vc!, animated: true)
            break
        case 3:
            Analytics.logEvent(Events.FAQ_TAPPED, parameters: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaqTVC") as? FaqTVC
            self.navigationController?.pushViewController(vc!, animated: true)
            break
        
        case 4:
            Analytics.logEvent(Events.CONTACT_US_TAPPED, parameters: nil)
            var nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
            let version = nsObject as! String
            nsObject = Bundle.main.infoDictionary!["CFBundleVersion"]
            let build = nsObject as! String
            
            if let url = URL(string: "mailto:aryan@freestand.in?subject=issue%20raised%20[iOS]&body=App%20version:%20\(version)%20(\(build))") {
                UIApplication.shared.open(url)
            }
            break
        case 5:
            Analytics.logEvent(Events.LOG_OUT_TAPPED, parameters: nil)
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
        UIApplication.shared.delegate?.window!?.rootViewController = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "SIgnInVC")
    }
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
            self.navigationController?.pushViewController(vc!, animated: true)
//        performSegue(withIdentifier: "moreToProfile", sender: nil)
    }
    
    
}
