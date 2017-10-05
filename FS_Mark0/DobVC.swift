//
//  DobVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class DobVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var male: RadioButton!
    @IBOutlet weak var female: RadioButton!
    var gender: String!
    
    enum Notifications: String, NotificationName {
        case phoneAuthVCNotification
    }
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        male.isSelected = true
        female.isSelected = false
    }
    
    @IBOutlet weak var dobField: UITextField!
    var datePicker : UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gender = "Male"
        dobField.delegate = self
        male.alternateButton = [female!]
        female.alternateButton = [male!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pickUpDate(_ textField : UITextField) {
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    
    }

    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dobField.text = dateFormatter1.string(from: datePicker.date)
        dobField.resignFirstResponder()
    }
    @objc func cancelClick() {
        dobField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.dobField)
    }
    
    @IBAction func maleRadioPressed(_ sender: Any) {
        gender = "Male"
    }
    
    @IBAction func femaleRadioPressed(_ sender: Any) {
        gender = "Female"
    }
    
    @IBAction func submitPressed(sender: Any) {
        
        
        let userData = ["dob":dobField.text, "gender":gender]
        DataService.ds.updateFirebaseDBUserWithUserData(userData: [userData as! Dictionary<String, String> as Dictionary<String, AnyObject>])
        
        
        let delegateTemp = UIApplication.shared.delegate
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notifications.phoneAuthVCNotification.name, object: nil)
        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()

    }
    
}
