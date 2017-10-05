//
//  BrandCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 27/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class BrandCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var totalDealsLabel: UILabel!
    
    var brand: Brand!

    func configureCell(brand: Brand){
        self.brand = brand
        img.downloadedFrom(link: brand.imgUrl!)
        totalDealsLabel.text = "\(brand.totalDeals!) DEALS AVAILABLE"
    }

}