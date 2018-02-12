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
        
        Analytics.logEvent(Events.SCREEN_LOGIN , parameters: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNotifReceived), name: Notification.Name("phoneAuthVCNotification"), object: nil)
    }

    @objc func dismissNotifReceived() {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        Analytics.logEvent(Events.FB_LOGIN, parameters: nil)
        fbBtn.isHidden = true
        activityIndicator.startAnimating()
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.fbBtn.isHidden = false
                let alert = UIAlertController(title: "Error", message: "Error while logging in: \(error?.localizedDescription ?? "")", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                print("FS: Unable to Authenticate with facebook -\(String(describing: error))")
            } else if result?.isCancelled == true {
                print("FS: User cancelled FB Auth")
                self.activityIndicator.stopAnimating()
                self.fbBtn.isHidden = false
                let alert = UIAlertController(title: "Error", message: "User Cancelled login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

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
                
                self.activityIndicator.stopAnimating()
                self.fbBtn.isHidden = false
                let alert = UIAlertController(title: "Error", message: "Error while logging in: \(error?.localizedDescription ?? "")", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                
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
                    DataService.ds.updateFirebaseDBUserWithUserData( userData: [userData as Dictionary<String, AnyObject>] )
                }
                
                if let user = user {
                    let userData = [["email":user.email],["name":user.displayName],["fcmToken":InstanceID.instanceID().token()]]
                    DispatchQueue.global(qos: .background).async {
                        self.getProfPic(fid: FBSDKAccessToken.current().userID)
                    }
                    print(user.uid)
                    print(userData)
                    self.completeSignIn(id: user.uid, userData: userData as! [Dictionary<String, String>])
                }
            }
        }
    }
    
    func completeSignIn(id: String, userData: [Dictionary<String, String>]) {
        DataService.ds.createFirebaseUserWithUID(uID: (Auth.auth().currentUser?.uid)!, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: "KEY_UID")
        print("FS: Data saved to keychain with result: \(keychainResult)")
        
        if let dob = UserDefaults.standard.string(forKey: "userDob"){
            if dob != "" {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.dismiss(animated: true, completion: nil)
                let delegateTemp = UIApplication.shared.delegate
                delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            } else {
                print("go to dob auth")
                self.dismiss(animated: true, completion: nil)
                let storyBoard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
                let DobVC = storyBoard.instantiateViewController(withIdentifier: "DobVC") as! DobVC
                self.present(DobVC, animated: true, completion: nil)
            }
        } else {
            DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    if let _ = dict["dob"] as? String {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(dict["gender"] as? String, forKey: "userGender")
                        self.dismiss(animated: true, completion: nil)
                        let delegateTemp = UIApplication.shared.delegate
                        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    } else {
                        print("go to dob auth")
                        self.dismiss(animated: true, completion: nil)
                        let storyBoard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
                        let DobVC = storyBoard.instantiateViewController(withIdentifier: "DobVC") as! DobVC
                        self.present(DobVC, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func getProfPic(fid: String) {
        print("getProfPic called")
        if (fid != "") {
            let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            let imgURL = NSURL(string: imgURLString)
            DataService.ds.updateFirebaseDBUserWithUserData( userData: [["photoURL": imgURLString as AnyObject]])
            let imageData = NSData(contentsOf: imgURL! as URL)
            UserDefaults.standard.set(imageData, forKey: "profImageData")
        }
    }
}
