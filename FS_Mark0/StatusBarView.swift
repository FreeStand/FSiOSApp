//
//  StatusBarView.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class StatusBarView: UIView {
    var label = UILabel()
    var backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCustomView() {
        backView.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height)
        
        if let font = UIFont(name: "AvenirNext-Bold", size: 12) {
            label.font = font
            label.text = "Next Box available on March 1 !!"
            let fontAttributes = [NSAttributedStringKey.font: font]
            let size = (label.text! as NSString).size(withAttributes: fontAttributes)
            label.frame = CGRect(x: UIApplication.shared.statusBarFrame.width, y: 0, width: size.width, height: UIApplication.shared.statusBarFrame.height)
        }
        label.backgroundColor = UIColor.fiBlack
        backView.backgroundColor = UIColor.fiBlack
        label.textColor = UIColor.white
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
        label.textAlignment = .justified
        self.addSubview(backView)
        self.addSubview(label)
        
        UIView.animate(withDuration: 6.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.label.center = CGPoint(x: 0 - self.label.bounds.size.width / 2, y: self.label.center.y)
        }, completion:  { _ in })

        
    }

}
