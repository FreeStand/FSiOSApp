//
//  SettingsVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 30/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.respondToEdgeGesture))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)
        
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    func respondToEdgeGesture (_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            performSegue(withIdentifier: "settingsToMore", sender: nil)
        }
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
