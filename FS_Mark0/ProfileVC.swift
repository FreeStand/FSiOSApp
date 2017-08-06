//
//  ProfileVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 30/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import FBSDKLoginKit


class ProfileVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var profImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderAgeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.respondToEdgeGesture))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)
        let imageData = UserDefaults.standard.object(forKey: "profImageData") as! NSData
        profImgView.maskCircle(anyImage: UIImage(data: imageData as Data)!)
 
        nameLabel.text = UserInfo.init().name
        emailLabel.text = UserInfo.init().email
        phoneLabel.text = UserDefaults.standard.string(forKey: "phoneNum")
        logOutBtn.layer.cornerRadius = 10
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        print("Log Out Btn Pressed")
        KeychainWrapper.standard.removeObject(forKey: "KEY_UID")
        try! Auth.auth().signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UIApplication.shared.delegate?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SIgnInVC")
    }
    
    func respondToEdgeGesture (_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            performSegue(withIdentifier: "profileToMore", sender: nil)
        }
    }
}
