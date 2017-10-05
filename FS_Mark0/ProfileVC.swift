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
        displayGenderBday()
    }
   
    func displayGenderBday() {
        DataService.ds.REF_USER_CURRENT.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                if let gender = dict["gender"] as? String {
                    self.genderLabel.text = gender
                } else {
                    print("Error: Can't fetch gender in ProfileVC")
                }
                if let bday = dict["dob"] as? String {
                    self.ageLabel.text = bday
                } else {
                    print("Error: Can't fetch age in ProfileVC")
                }
            }
        })
    }
}
