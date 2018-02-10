//
//  FaqTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 05/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class FaqTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var faqList = [FAQ]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImg: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backgroundImg.clipsToBounds = true
        
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
        Alamofire.request(APIEndpoints.faqEndpoint).responseJSON { (res) in
            self.faqList.removeAll()
            if let alertArray = res.result.value as? [[String: String]] {
                for dict in alertArray {
                    let alert = FAQ()
                    if let answer = dict["answer"] {
                        alert.answer = answer
                    } else {
                        print("Error: Can't cast answer in FAQs")
                    }
                    if let question = dict["question"] {
                        alert.question = question
                    } else {
                        print("Error: Can't cast question in FAQs")
                    }
                    
                    self.faqList.append(alert)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("Can't cast alerts in FAQs")
            }
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

