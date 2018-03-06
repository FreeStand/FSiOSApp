//
//  FaqTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 05/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD

class FaqTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var faqList = [FAQ]()
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                
        self.navigationItem.title = "FAQs"

        self.tableView.tableFooterView = UIView()
        
        let rc = UIRefreshControl()
        tableView.refreshControl = rc
        
        rc.addTarget(self, action: #selector(refresh(refreshControl:)), for: UIControlEvents.valueChanged)

        
        getFAQs()
        
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        getFAQs()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    
    func getFAQs() {
        SVProgressHUD.show()
        APIService.shared.fetchFaqs { (faqList) in
            self.faqList = faqList
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as? FAQCell {
            
            let faq: FAQ!
            faq = faqList[indexPath.row]
            
            cell.configureCell(faq: faq)
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
}

