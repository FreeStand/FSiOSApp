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
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var SendCodeBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let phonePrefix = "+91"
    var phoneNumber: String!
    let limitLength = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        let border = CALayer()
        let width = CGFloat(2.0)
        textField.becomeFirstResponder()
        SendCodeBtn.alpha = 0.5
//        3A7CFF
        border.borderColor = UIColor().HexToColor(hexString: "#3A7CFF", alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        SendCodeBtn.layer.cornerRadius = 5
        SendCodeBtn.isEnabled = false
        
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }

    @IBAction func SendCodeBtnPressed(_ sender: Any) {
        
        activityIndicator.isHidden  = false
        activityIndicator.startAnimating()
        UserDefaults.standard.set(phoneNumber, forKey: "PhoneNum")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNumber) { (verificationID, error) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            if error != nil {
                print("Error: \(error.debugDescription)")
            } else {
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

    func editingChanged() {
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
