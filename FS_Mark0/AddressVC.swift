//
//  AddressVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 24/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

protocol AddressViewControllerDelegate {
    func addressViewControllerResponse(address: Address)
}

class AddressVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var al1: UITextField!
    @IBOutlet weak var al2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var pincode: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!

    var delegate: AddressViewControllerDelegate?
    var statePicker: UIPickerView!
    
    let statePickerValues = ["Delhi", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu & Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttarakhand", "Uttar Pradesh", "West Bengal", "Andaman and Nicobar Islands", "Chandigarh", "Dadra & Nagar Haveli", "Daman & Diu", "Lakshadweep", "Puducherry"]



    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImg.clipsToBounds = true
        nickName.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        al1.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        al2.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        city.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        pincode.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        self.submitBtn.layer.cornerRadius = 2.0

        self.shadowView.layer.cornerRadius = 2.0
        self.shadowView.layer.borderWidth = 1.0
        self.shadowView.layer.borderColor = UIColor.clear.cgColor
        self.shadowView.layer.masksToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize.zero
        self.shadowView.layer.shadowRadius = 1.0
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.masksToBounds = false
//        self.shadowView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.shadowView.bounds.width, height: self.shadowView.bounds.height)).cgPath
        self.shadowView.layer.shouldRasterize = true

        print("Shadow: \(self.shadowView.bounds)")
        pincode.delegate = self

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
        nickName.resignFirstResponder()
    }
    
    @objc func editingChanged() {
        if pincode.text?.count == 6 && al1.text?.count != 0 && al2.text?.count != 0 && city.text?.count != 0 && nickName.text?.count != 0 {
            submitBtn.alpha = 1.0
            submitBtn.isEnabled = true
        } else {
            submitBtn.alpha = 0.5
            submitBtn.isEnabled = false
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        let address = Address()
        address.addressLine1 = al1.text!
        address.addressLine2 = al2.text!
        address.city = city.text!
        address.pincode = pincode.text!
        address.state = state.text!
        address.nickname = nickName.text!
        self.navigationController?.popViewController(animated: true)
        self.delegate?.addressViewControllerResponse(address: address)
    }
    
}
