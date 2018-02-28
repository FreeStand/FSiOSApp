//
//  WebVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 26/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var url: String!
    var progressView: UIProgressView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Behrouz Biryani"
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2))
        progressView.progressViewStyle = .default
        progressView.sizeToFit()
        self.view.addSubview(progressView)

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        // Do any additional setup after loading the view.
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress == 1.0 {
                progressView.isHidden = true
            }
        }
    }

}
