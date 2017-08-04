//
//  ViewController.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 26/06/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var isLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.readPermissions = ["public_profile","email"]
     
        loginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && isLoggedIn == true)
        {
            performSegue(withIdentifier: "fbToQR", sender: self)
        }
    }


    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did Log Out from FB")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }else {
            print("Successfully logged in with facebook")
            isLoggedIn = true
//            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email, name, gender, id"]).start { (connection, result, err) in
                
                guard let result = result as? NSDictionary, let email = result["email"] as? String,
                    let user_name = result["name"] as? String,
                    let user_gender = result["gender"] as? String,
                    let user_id_fb = result["id"]  as? String else {
                        return
                }
                print(user_name)
                print(email)
                print(user_gender)
                print(user_id_fb)
                self.performSegue(withIdentifier: "fbToQR", sender: self)

                
                if err != nil {
                    print("Failed to start graph request:", err!)
                    self.isLoggedIn = false
                    return
                }
            }
            
        }
    }
}

