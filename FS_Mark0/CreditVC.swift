//
//  CreditVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 17/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CreditVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var youTubeBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        fbBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        twitterBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        youTubeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        instagramBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        fbBtn.setTitle(String.fontAwesomeIcon(name: .facebook), for: .normal)
        twitterBtn.setTitle(String.fontAwesomeIcon(name: .twitter), for: .normal)
        youTubeBtn.setTitle(String.fontAwesomeIcon(name: .youTube), for: .normal)
        instagramBtn.setTitle(String.fontAwesomeIcon(name: .instagram), for: .normal)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.respondToEdgeGesture))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)

    }
    
    func respondToEdgeGesture (_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            performSegue(withIdentifier: "creditToMain", sender: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
