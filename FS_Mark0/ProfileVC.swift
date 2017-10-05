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


class ProfileVC: UIViewController {
    
    @IBOutlet weak var profImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageData = UserDefaults.standard.object(forKey: "profImageData") as! NSData
        profImgView.maskCircle(anyImage: UIImage(data: imageData as Data)!)
 
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        emailLabel.text = UserInfo.ui.email
        nameLabel.text = UserInfo.ui.name
        phoneLabel.text = UserInfo.ui.phoneNo
        ageLabel.text = UserInfo.ui.dob
        genderLabel.text = UserInfo.ui.gender
    }
}
