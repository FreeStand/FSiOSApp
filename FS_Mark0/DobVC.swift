//
//  DobVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class DobVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var male: RadioButton!
    @IBOutlet weak var female: RadioButton!
    @IBOutlet weak var others: RadioButton!
    @IBOutlet weak var ageTextField: UITextField!
    var gender: String!
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        male.isSelected = false
        female.isSelected = false
    }
    
    enum Notifications: String, NotificationName {
        case phoneAuthVCNotification
    }

    
    var agePicker: UIPickerView!
    
    let agePickerValues = ["Below 18","18-24", "25-30", "31-36", "37-42", "43-49", "Above 50"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        agePicker = UIPickerView()
        gender = "Male"
        ageTextField.delegate = self
        agePicker.delegate = self
        agePicker.dataSource = self
        male.alternateButton = [female!, others!]
        female.alternateButton = [male!, others!]
        others.alternateButton = [male!, female!]
        
        ageTextField.inputView = agePicker
        ageTextField.text = agePickerValues[0]
        ageTextField.becomeFirstResponder()
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        ageTextField.inputAccessoryView = toolBar

    }

    @objc func doneClick() {
        ageTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        ageTextField.resignFirstResponder()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return agePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return agePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = agePickerValues[row]
    }
    
    @IBAction func maleRadioPressed(_ sender: Any) {
        gender = "Male"
        male.unselectAlternateButtons()
        print(gender)
    }
    
    @IBAction func femaleRadioPressed(_ sender: Any) {
        gender = "Female"
        female.unselectAlternateButtons()
        print(gender)
    }
    
    @IBAction func otherRadioPressed(_ sender: Any) {
        gender = "others"
        others.unselectAlternateButtons()
        print(gender)
    }
    
    @IBAction func submitPressed(sender: Any) {
        
        UserDefaults.standard.set(ageTextField.text, forKey: "userDob")
        UserDefaults.standard.set(gender,forKey: "userGender")
        
        let userData = ["dob":ageTextField.text, "gender":gender]
        DataService.ds.updateFirebaseDBUserWithUserData(userData: [userData as! Dictionary<String, String> as Dictionary<String, AnyObject>])
        
//        self.performSegue(withIdentifier: "dobToFeedback", sender: nil)
//        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        let delegateTemp = UIApplication.shared.delegate
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notifications.phoneAuthVCNotification.name, object: nil)
        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()

        
    }
}
