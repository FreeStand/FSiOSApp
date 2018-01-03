//
//  AddressVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 24/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class AddressVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var al1: UITextField!
    @IBOutlet weak var al2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var pincode: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var statePicker: UIPickerView!
    
    let statePickerValues = ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu & Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttarakhand", "Uttar Pradesh", "West Bengal", "Andaman and Nicobar Islands", "Chandigarh", "Delhi", "Dadra & Nagar Haveli", "Daman & Diu", "Lakshadweep", "Puducherry"]



    override func viewDidLoad() {
        super.viewDidLoad()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor().HexToColor(hexString: "#FF644B", alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: al1.frame.size.height - width, width:  al1.frame.size.width, height: al1.frame.size.height)
        
        border.borderWidth = width
        
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.layer.addSublayer(border)
                textField.layer.masksToBounds = true
            }
        }
        
//        al1.layer.addSublayer(border)
//        al1.layer.masksToBounds = true
//        al2.layer.addSublayer(border)
//        al2.layer.masksToBounds = true
//        city.layer.addSublayer(border)
//        city.layer.masksToBounds = true
//        pincode.layer.addSublayer(border)
//        pincode.layer.masksToBounds = true
//        state.layer.addSublayer(border)
//        state.layer.masksToBounds = true
        
        al1.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        al2.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        city.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        pincode.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        
//        al1.delegate = self
//        al2.delegate = self
//        city.delegate = self
        pincode.delegate = self
//        state.delegate = self

        statePicker = UIPickerView()
        statePicker.delegate = self
        statePicker.dataSource = self
        state.inputView = statePicker
        state.text = statePickerValues[0]
        
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
        state.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        state.resignFirstResponder()
    }
    @objc func cancelClick() {
        state.resignFirstResponder()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state.text = statePickerValues[row]
        //        self.view.endEditing(true)
    }
    
    
    // MARK: TextField Delegates
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        al1.resignFirstResponder()
        al2.resignFirstResponder()
        city.resignFirstResponder()
        pincode.resignFirstResponder()
        state.resignFirstResponder()
    }
    
    @objc func editingChanged() {
        if pincode.text?.count == 6 && al1.text?.count != 0 && al2.text?.count != 0 && city.text?.count != 0 {
            submitBtn.alpha = 1.0
            submitBtn.isEnabled = true
        } else {
            submitBtn.alpha = 0.5
            submitBtn.isEnabled = false
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        DataService.ds.REF_USER_CURRENT.updateChildValues(["address": "\(al1.text!), \(al2.text!), \(city.text!), \(pincode.text!), \(state.text!) "])
        performSegue(withIdentifier: "addressToThankYou", sender: nil)
        UserDefaults.standard.set(true, forKey: "hasAddress")
        
    }
}
