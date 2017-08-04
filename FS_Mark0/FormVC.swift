//
//  FormVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 09/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import WebKit

class FormVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func surveybtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
    @IBAction func earnCreditsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toEarnCreditsVC", sender: nil)
    }
    
    // MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            if let vc = segue.destination as? WebViewVC {
                vc.url = NSURL(string: "https://www.surveymonkey.com/r/KL6GZJX")! as URL
            }
        }
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
    }

}
