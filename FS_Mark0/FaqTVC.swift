//
//  FaqTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 05/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class FaqTVC: UITableViewController {
    
    var faqList = [FAQ]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "FAQs"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.tableFooterView = UIView()
        
        getFAQs()
        
    }
    
    func getFAQs() {
        
        DataService.ds.REF_FAQ.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let faq = FAQ()
                if let question = dict["question"] as? String {
                    faq.question = question
                } else {
                    print("Error: Can't cast question in FAQ")
                }
                if let answer = dict["answer"] as? String {
                    faq.answer = answer
                } else {
                    print("Error: Can't cast answer in FAQ")
                }
                self.faqList.append(faq)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                print("Error: Can't cast FAQs")
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as? FAQCell {
            
            let faq: FAQ!
            faq = faqList[indexPath.row]
            
            cell.configureCell(faq: faq)
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
}

