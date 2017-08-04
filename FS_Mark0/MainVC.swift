//
//  MainVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 28/06/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import FBSDKLoginKit

class MainVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var uidLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = UserInfo.init().name
        emailLbl.text = UserInfo.init().email
        uidLbl.text = UserInfo.init().uid
    }
    

    @IBAction func logOutBtnTapped(_ sender: Any) {
        print("Log Out Btn Pressed")
        KeychainWrapper.standard.removeObject(forKey: "KEY_UID")
        try! Auth.auth().signOut()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UIApplication.shared.delegate?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SIgnInVC")

    }


}
