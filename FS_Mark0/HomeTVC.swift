//
//  HomeTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 31/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

class HomeTVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    
    var brandList = [BrandCV]()
    var surveyList = [Survey]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "freestandLogoWhite.png")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        
        heights.tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        heights.navBarHeight = (self.navigationController?.navigationBar.frame.height)!
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "CVCell", bundle: nil), forCellWithReuseIdentifier: "CVCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        getBrands()
        getSurveys()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as? CVCell {
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.borderWidth = 2
            
            let brand: BrandCV!
            brand = brandList[indexPath.row]
            cell.configureCell(brand: brand)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func getBrands() {
        Alamofire.request(APIEndpoints.getBrands).responseJSON { (response) in
            if let response = response.result.value as? [String: NSDictionary] {
                for (_, dict) in response {
                    let brand = BrandCV()
                    if let imgURL = dict["imgURL"] as? String {
                        brand.imgURL = imgURL
                    } else {
                        print("Error: Can't cast imgURL in CollectionView")
                    }
                    
                    if let name = dict["name"] as? String {
                        brand.name = name
                    } else {
                        print("Error: Can't cast name in CollectionView")
                    }
                    
                    if let redirectURL = dict["redirectURL"] as? String {
                        brand.redirectURL = redirectURL
                    } else {
                        print("Error: Can't cast redirectURL in CollectionView")
                    }
                    
                    self.brandList.append(brand)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = brandList[indexPath.row]
        UIApplication.shared.open(URL(string: brand.redirectURL!)!, options: [:], completionHandler: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as? SurveyCell {
            let survey: Survey!
            survey = surveyList[indexPath.row]
            cell.configureCell(survey: survey)
            cell.contentView.addBottomBorderWithColor(color: UIColor.white, width: 4)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let survey = surveyList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
        vc?.quesArray = survey.quesArray
        vc?.sender = "HomeTVC"
        self.present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getSurveys() {
        Alamofire.request("\(APIEndpoints.sendSurveysEndpoint)?uid=\(UserInfo.uid!)&gender=\(UserInfo.gender!)").responseJSON { (response) in
            if let responseArray = response.result.value as? [NSDictionary] {
                for card in responseArray {
                    let survey = Survey()
                    if let imgURL = card["imgURL"] as? String {
                        survey.imgURL = imgURL
                    } else {
                        print("Can't cast imgURL in HomeTVC getSurveys")
                    }
                    if let title = card["title"] as? String {
                        survey.title = title
                    } else {
                        print("Can't cast title in HomeTVC getSurveys")
                    }
                    if let subtitle = card["subtitle"] as? String {
                        survey.subtitle = subtitle
                    } else {
                        print("Can't cast subtitle in HomeTVC getSurveys")
                    }
                    if let taken = card["taken"] as? Bool {
                        survey.taken = taken
                    } else {
                        print("Can't cast taken in HomeTVC getSurveys")
                    }
                    if let questions = card["questions"] as? NSArray {
                        survey.quesArray = questions
                    } else {
                        print("Can't cast questions in HomeTVC getSurveys")
                    }
                    
                    self.surveyList.append(survey)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            } else {
                print("Can't cast Array in HomeTVC getSurveys")
            }
        }
    }
    
}

