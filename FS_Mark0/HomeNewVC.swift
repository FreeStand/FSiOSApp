//
//  HomeNewVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 09/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class HomeNewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topImgView: UIImageView!
    @IBOutlet weak var moreSamplesBtn: UIButton!
    
    var brandList = [Brand]()
    var imgList = [String]()
    var selectedBrand: Brand!
    var isBarHidden = true
    var questions: NSDictionary!
    var iterator = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubview(toFront: loadingView)
        self.navigationController?.navigationBar.layer.zPosition = -1
        self.tabBarController?.tabBar.layer.zPosition = -1
        indicatorView.startAnimating()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "freestandLogoWhite.png")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        getBrands()
        genderAgeCheck()
        let hasAdress = UserDefaults.standard.bool(forKey: "hasAdress")
        if hasAdress{
            moreSamplesBtn.isEnabled = false
            moreSamplesBtn.alpha = 0.5
            
        }
    }
    
    
    func genderAgeCheck() {
        if let _ = UserDefaults.standard.string(forKey: "userGender"), let _ = UserDefaults.standard.string(forKey: "userDob"), let _ = UserDefaults.standard.string(forKey: "hasAddress"){
        } else {
            DataService.ds.REF_USER_CURRENT.observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    if let gender = dict["gender"] as? String {
                        UserDefaults.standard.set(gender, forKey: "userGender")
                    }
                    if let ageGroup = dict["dob"] as? String {
                        UserDefaults.standard.set(ageGroup, forKey: "userDob")
                    }
                    if let _ = dict["address"] as? String {
                        UserDefaults.standard.set(true, forKey: "hasAdress")
                        self.moreSamplesBtn.isEnabled = false
                        self.moreSamplesBtn.alpha = 0.5
                    }
                }
            })
        }
    }

    func getBrands() {
        DataService.ds.REF_BRANDS.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let brand = Brand()
                
                let name = snapshot.key
                brand.name = name
            
                if let imgURL = dict["imgURL"] as? String {
                    brand.imgUrl = imgURL
                    self.imgList.append(imgURL)
                } else {
                    print("Error: Can't find/cast URL in \(brand.name ?? "Brand")")
                }
                
                if let questions = dict["questions"] as? NSDictionary {
                    brand.questions = questions
                } else {
                    print("Error: Can't find/cast questions in \(brand.name ?? "Brand")")
                }
                
                if let coupons = dict["coupons"] as? [String: [String: Any]] {
                    brand.coupons = coupons
                    brand.totalDeals = coupons.count
                } else {
                    print("Error: Can't find/cast coupons in \(brand.name ?? "Brand")")
                }
                
                self.brandList.append(brand)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.isBarHidden {
                        self.topImgView.downloadedFrom(link: self.imgList[0])
                        _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(HomeNewVC.animateImg), userInfo: nil, repeats: true)
                        self.isBarHidden = false
                        self.showBars()
                    }
                }
            } else {
                print("Error: Can't cast dict from snapshot in Brands")
            }
        }) { (error) in
            print("Error: Can't load Brands from Brands DB")
        }
    }
    
    @IBAction func moreSamplesBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToMoreSamples", sender: nil)
    }

    @objc func animateImg() {
        if iterator < brandList.count {
            UIView.transition(with: self.topImgView, duration: 0.2, options: .transitionFlipFromLeft, animations: {
                self.topImgView.downloadedFrom(link: self.imgList[self.iterator])
            }, completion: nil)
            iterator = iterator + 1
        } else if iterator == brandList.count {
            UIView.transition(with: self.topImgView, duration: 0.2, options: .transitionFlipFromLeft, animations: {
                self.topImgView.downloadedFrom(link: self.imgList[0])
            }, completion: nil)
            iterator = 1
        }
    }
    
    func showBars() {
        view.sendSubview(toBack: loadingView)
        self.loadingView.isHidden = true
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.indicatorView.stopAnimating()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as? BrandCell {
            cell.contentView.addBottomBorderWithColor(color: UIColor().HexToColor(hexString: "#393939", alpha: 1.0), width: 8.0)
            cell.clipsToBounds = true
            
            let brand: Brand!
            brand = brandList[indexPath.row]
            cell.configureCell(brand: brand)

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("BrandCell")
        selectedBrand = brandList[indexPath.row]
        if selectedBrand.coupons != nil {
            performSegue(withIdentifier: "homeToCoupon", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToCoupon" {
            if let vc = segue.destination as? NewCouponVC {
                vc.brand = self.selectedBrand
            }
        } else if segue.identifier == "homeToMoreSamples" {
            if let vc = segue.destination as? MoreSamplesVC {
                vc.brandList = self.brandList
            }
        }
    }

}
