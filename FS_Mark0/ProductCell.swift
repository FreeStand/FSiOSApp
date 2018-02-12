//
//  ProductCell.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 11/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var product: Product!
    
    func configureCell(product: Product) {
        self.product = product
        nameLbl.text = product.name!
        priceLbl.text = "Rs. " + product.price! + "/-"
        imgView.downloadedFrom(link: product.imgURL!)
        imgView.layer.cornerRadius = 2
    }
    

}
