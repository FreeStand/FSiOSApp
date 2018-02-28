//
//  DobVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class DobVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var male: RadioButton!
    @IBOutlet weak var female: RadioButton!
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
        
        Analytics.logEvent(Events.SCREEN_DOB, parameters: nil)
        agePicker = UIPickerView()
        gender = "Male"
        ageTextField.delegate = self
        agePicker.delegate = self
        agePicker.dataSource = self
        male.alternateButton = [female!]
        female.alternateButton = [male!]
        
        ageTextField.inputView = agePicker
        ageTextField.text = agePickerValues[0]
        ageTextField.becomeFirstResponder()
        
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
    
    @IBAction func submitPressed(sender: Any) {
        Analytics.logEvent(Events.DOB_CONFIRM, parameters: nil)
        switch gender {
        case "Male":
            Analytics.logEvent(Events.GENDER_MALE_SEL, parameters: nil)
        case "Female":
            Analytics.logEvent(Events.GENDER_FEMALE_SEL, parameters: nil)
        default:
            print("Error: No Gender Selected")
        }
        
        UserDefaults.standard.set(ageTextField.text, forKey: "userDob")
        UserDefaults.standard.set(gender,forKey: "userGender")
        
        let userData = ["dob":ageTextField.text, "gender":gender]
        DataService.ds.updateFirebaseDBUserWithUserData(userData: [userData as! Dictionary<String, String> as Dictionary<String, AnyObject>])
        let storyBoard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let LocationVC = storyBoard.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        self.present(LocationVC, animated: true, completion: nil)
        
    }
}
