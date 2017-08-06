//
//  SIgnInVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 27/06/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class SIgnInVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var fbBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        fbBtn.isHidden = true
        activityIndicator.startAnimating()
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("FS: Unable to Authenticate with facebook -\(String(describing: error))")
            } else if result?.isCancelled == true {
                print("FS: User cancelled FB Auth")
            } else {
                print("FS: successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        
        
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("FS: Unable to authenticate with Firebase")
            } else {
                print("FS: Successfully authenticated with Firebase")
                print("Current User: \(String(describing: user)) in FB Auth")
                
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": " gender"]).start { (connection, result, err) in
                    
                    guard let result = result as? NSDictionary,
                        let user_gender = result[["gender"]] as? String else {
                            return
                    }
                    print(user_gender)
                    let userData = ["gender":user_gender]
                    DataService.ds.updateFirebaseDBUserGender(uID: (user?.uid)!, gender: userData)
                }
                
                
                if let user = user {
                    let userData = [["email":user.email],["name":user.displayName]]
                    DispatchQueue.global(qos: .background).async {
                        self.getProfPic(fid: FBSDKAccessToken.current().userID)
                    }
                    self.completeSignIn(id: user.uid, userData: userData as! [Dictionary<String, String>])
                }
            }
        }
    }
    
    func completeSignIn(id: String, userData: [Dictionary<String, String>]) {
        DataService.ds.createFirebaseDBUser(uID: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: "KEY_UID")
        print("FS: Data saved to keychain with result: \(keychainResult)")

        
        let user = Auth.auth().currentUser
        if user?.phoneNumber != nil {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            let delegateTemp = UIApplication.shared.delegate
            delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        } else {
            print("go to phone auth")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let PhoneAuthVC = storyBoard.instantiateViewController(withIdentifier: "PhoneAuthVC") as! PhoneAuthVC
            self.present(PhoneAuthVC, animated: true, completion: nil)
        }
    }
    
    func getProfPic(fid: String) {
        print("getProfPic called")
        if (fid != "") {
            let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOf: imgURL! as URL)
            UserDefaults.standard.set(imageData, forKey: "profImageData")
        }
    }
    


}