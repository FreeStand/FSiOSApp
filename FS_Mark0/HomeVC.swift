//
//  HomeVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 29/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var NextCardView: UIView!
    @IBOutlet weak var ProductCardView: UIView!
    @IBOutlet weak var FeedbackCardView: UIView!
    @IBOutlet weak var ShareCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topCardView.layer.cornerRadius = 5
        self.NextCardView.layer.cornerRadius = 5
        self.ProductCardView.layer.cornerRadius = 5
        self.FeedbackCardView.layer.cornerRadius = 5
        self.ShareCardView.layer.cornerRadius = 5
        
        self.topCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.NextCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.ProductCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.FeedbackCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        self.ShareCardView.layer.borderColor = UIColor().HexToColor(hexString: "#D9E0F4", alpha: 1.0).cgColor
        
        self.topCardView.layer.borderWidth = 0.5
        self.NextCardView.layer.borderWidth = 0.5
        self.ProductCardView.layer.borderWidth = 0.5
        self.FeedbackCardView.layer.borderWidth = 0.5
        self.ShareCardView.layer.borderWidth = 0.5


        
        self.topCardView.clipsToBounds = true
        self.NextCardView.clipsToBounds = true
        self.ProductCardView.clipsToBounds = true
        self.FeedbackCardView.clipsToBounds = true
        self.ShareCardView.clipsToBounds = true
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
