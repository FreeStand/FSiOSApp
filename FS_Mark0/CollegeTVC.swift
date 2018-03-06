//
//  CollegeTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 10/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth.FIRAuth

struct College: Codable {
    var name: String?
    var abbreviation: String?
}

class CollegeTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var inSearchMode = false
    
    var collegeList: [College]!
    var filteredCollegeList = [College]()
    let searchController = UISearchController(searchResultsController: nil)
    var quesArray: [APIService.Question]!
    var surveyID: String!
    var sender = FeedbackSender.eventQR
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        self.navigationItem.title = "Choose your College"
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            // to dismiss keyboard
            view.endEditing(true)
            tableView.reloadData()
        }else{
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            // $0 is like a var that holds the pokemon being grabbed while filtering
            filteredCollegeList = collegeList.filter({ (college: College) -> Bool in
                return (college.name?.lowercased().contains(lower))! || (college.abbreviation?.lowercased().contains(lower))!
            })
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredCollegeList.count
        }
        return collegeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CollegeCell", for: indexPath) as? CollegeCell {
            let college: College!
            if inSearchMode {
                college = filteredCollegeList[indexPath.row]
            } else {
                college = collegeList[indexPath.row]
            }
            cell.configureCell(college: college)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let college: College!
        if inSearchMode {
            college = filteredCollegeList[indexPath.row]
        } else {
            college = collegeList[indexPath.row]
        }
        print(college.name!)
        
        DataService.ds.REF_USER_CURRENT.updateChildValues(["college": college.name!])
        DataService.ds.REF_COLLEGES.child(college.abbreviation!).child("users").updateChildValues([(Auth.auth().currentUser?.uid)!:true])

        let FeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
        FeedbackVC?.sender = self.sender
        FeedbackVC?.quesArray = self.quesArray
        FeedbackVC?.surveyID = self.surveyID
        self.navigationController?.pushViewController(FeedbackVC!, animated: true)
    }

    
}
