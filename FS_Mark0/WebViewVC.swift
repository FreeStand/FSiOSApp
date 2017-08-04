//
//  WebViewVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 17/07/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var url: URL!
    var request: URLRequest!
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        webView.delegate = self
        request = URLRequest(url: url)
        webView.loadRequest(request)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.respondToEdgeGesture))
        edgeGesture.edges = .left
        webView.addGestureRecognizer(edgeGesture)
    
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func respondToEdgeGesture (_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            performSegue(withIdentifier: "webToCreditVC", sender: nil)
        }
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
