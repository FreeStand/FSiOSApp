//
//  BottomTextField.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 24/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class BottomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor().HexToColor(hexString: "#FF644B", alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}
