//
//  PhoneAuthVerificationVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 06/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import Toaster

class PhoneAuthVerificationVC: UIViewController, UITextFieldDelegate {
    
    enum Notifications: String, NotificationName {
        case phoneAuthVCNotification
    }
    var phoneNum: String!

    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let limitLength = 6

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyBtn.alpha = 0.5
        verifyBtn.isEnabled = false
        verificationCode.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        verificationCode.delegate = self
        activityIndicator.isHidden = true
        phoneLabel.text = UserDefaults.standard.string(forKey: "PhoneNum")!
        verifyBtn.layer.cornerRadius = 5
        verificationCode.becomeFirstResponder()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor().HexToColor(hexString: "#3A7CFF", alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: verificationCode.frame.size.height - width, width:  verificationCode.frame.size.width, height: verificationCode.frame.size.height)
        
        border.borderWidth = width
        verificationCode.layer.addSublayer(border)
        verificationCode.layer.masksToBounds = true
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        verificationCode.resignFirstResponder()
    }
    
    @IBAction func ResendBtnPressed(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(UserDefaults.standard.string(forKey: "PhoneNum")!, uiDelegate: nil) { (verificationID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVID")
            }
        }
    }
    
    
    
    @IBAction func VerifyBtnPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        verificationCode.resignFirstResponder()
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: verificationCode.text!)
        
        Auth.auth().currentUser?.link(with: credential, completion: { (user, error) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            if error != nil {
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .credentialAlreadyInUse:
                        Toast(text: "Phone Number already in Use", delay: Delay.short, duration: Delay.long).show()
                        print("Phone Number already linked")
                    case .invalidVerificationCode:
                        print("Invalid OTP")
                        Toast(text: "Incorrect OTP", delay: Delay.short, duration: Delay.long).show()
                    case .sessionExpired:
                        Toast(text: "Session Expired. Please resend the Verification Code", delay: Delay.short, duration: Delay.long).show()
                        print("Session expired")
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
            } else {
                UserDefaults.standard.set(user?.phoneNumber, forKey: "phoneNum")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                
                let userData = ["phoneNo":user?.phoneNumber]
                DataService.ds.updateFirebaseDBUserWithUserData(userData: [userData as! Dictionary<String, String> as Dictionary<String, AnyObject>])
                
                self.performSegue(withIdentifier: "toDOB", sender: nil)

            }
        })
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToPhoneAuth", sender: nil)
    }
    
    // MARK: TextField Delegates
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    @objc func editingChanged() {
        if verificationCode.text?.count == 6 {
            verifyBtn.alpha = 1.0
            verifyBtn.isEnabled = true
        }else {
            verifyBtn.isEnabled = false
            verifyBtn.alpha = 0.5
        }
    }


    
}
