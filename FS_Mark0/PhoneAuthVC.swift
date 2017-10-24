//
//  PhoneAuthVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 05/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth



class PhoneAuthVC: UIViewController, UITextFieldDelegate {
    enum Notifications: String, NotificationName {
        case phoneAuthNotification
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var SendCodeBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let phonePrefix = "+91"
    var phoneNumber: String!
    let limitLength = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        textField.becomeFirstResponder()
        SendCodeBtn.alpha = 0.5

        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor().HexToColor(hexString: "#3A7CFF", alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        SendCodeBtn.layer.cornerRadius = 5
        SendCodeBtn.isEnabled = false
        
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        textField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(dismissNotifReceived), name: Notification.Name("phoneAuthVCNotification"), object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    @objc func dismissNotifReceived() {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notifications.phoneAuthNotification.name, object: nil)
    }
    
    @IBAction func SendCodeBtnPressed(_ sender: Any) {
        
        activityIndicator.isHidden  = false
        activityIndicator.startAnimating()
        UserDefaults.standard.set(phoneNumber, forKey: "PhoneNum")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { (verificationID, error) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVID")
                self.performSegue(withIdentifier: "code", sender: nil)
            }
        }
    }
    
    // MARK: TextField Delegates
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    
    }
    
 
    // MARK: Helpers
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
    }

    @objc func editingChanged() {
        if textField.text?.characters.count == 10 {
            SendCodeBtn.alpha = 1.0
            SendCodeBtn.isEnabled = true
            phoneNumber = phonePrefix + textField.text!
        }else {
            SendCodeBtn.isEnabled = false
            SendCodeBtn.alpha = 0.5
        }
    }

    
}
