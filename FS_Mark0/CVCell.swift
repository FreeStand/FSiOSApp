//
//  CVCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 04/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CVCell: UICollectionViewCell {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    
    let screenHeight = UIScreen.main.bounds.size.height
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let gapBwViews: CGFloat = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        
        print("Aryan: \(self.contentView.frame.height)")
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint.constant = screenHeight - screenHeight*0.6 - (heights.navBarHeight + heights.tabBarHeight + statusBarHeight + gapBwViews + 2*8)
        widthConstraint.constant = heightConstraint.constant
        
        imgHeightConstraint.constant = heightConstraint.constant*4/5 - 2*8
        imgWidthConstraint.constant = imgHeightConstraint.constant
        imgView.maskCircle(anyImage: UIImage(named: "beerproducts")!)

    }
    
    func configureCell(brand: BrandCV) {
        self.priceLabel.text = brand.name!
        imgView.downloadedFrom(link: brand.imgURL!)
    }

}
