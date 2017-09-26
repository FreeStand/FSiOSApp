//
//  WebViewVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 17/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url: URL!
    var request: URLRequest!
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "freestandLogoWhite.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        print("viewDidLoad")
        webView.delegate = self
        request = URLRequest(url: url)
        webView.loadRequest(request)
        
//        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
       
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Loading Started")
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Load finished sucessfully")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("load failed")
        print(error.localizedDescription)
        activityIndicator.stopAnimating()
    }
    
}
