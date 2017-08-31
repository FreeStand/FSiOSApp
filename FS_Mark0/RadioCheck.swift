//
//  RadioCheck.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.setBackgroundImage(UIImage(named: "RadioOff"), for: .normal)
    }
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        }else{
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setImage(UIImage(named: "radioOn"), for: .normal)
            } else {
                self.setImage(UIImage(named: "radioOff"), for: .normal)
            }
        }
    }
}
