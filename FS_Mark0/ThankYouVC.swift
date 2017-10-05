//
//  ThankYouVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class ThankYouVC: UIViewController {
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        doneBtn.layer.cornerRadius = 18
    }

    override func viewDidAppear(_ animated: Bool) {
//        let url = "https://media.giphy.com/media/l1J9OZpaWVfmDs27S/giphy.gif"
//        let gif = UIImage.gifImageWithURL(gifUrl: url)
//        imgView.image = gif
    }

    @IBAction func tyBtnPressed(_ sender: Any?) {
        print("pressed")
        performSegue(withIdentifier: "ThankYouUnwind", sender: self)
    }
}
