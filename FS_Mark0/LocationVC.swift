//
//  LocationVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 11/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class LocationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(Events.SCREEN_LOCATION, parameters: nil)
        // Do any additional setup after loading the view.
    }

    @IBAction func partnerBtnPressed(_ sender: UIButton) {
        Analytics.logEvent(Events.USER_CAMPAIGN, parameters: nil)
        // Present QR Screen here
//        self.dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EventFeedbackVC = storyBoard.instantiateViewController(withIdentifier: "QRScanVC") as! QRScanVC
        self.present(EventFeedbackVC, animated: true, completion: nil)
    }

    @IBAction func otherBtnPressed(_ sender: UIButton) {
        Analytics.logEvent(Events.USER_ONLINE, parameters: nil)
        // Present Home Screen here
        let delegateTemp = UIApplication.shared.delegate
//        self.dismiss(animated: true, completion: nil)
        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()

    }

}
