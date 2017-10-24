//
//  ThankYouVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class ThankYouVC: UIViewController {
    
    enum Notifications: String, NotificationName {
        case phoneAuthVCNotification
    }
    
    
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
        
        let delegateTemp = UIApplication.shared.delegate
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notifications.phoneAuthVCNotification.name, object: nil)
        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//        self.performSegue(withIdentifier: "dobToFeedback", sender: nil)

    }
}
