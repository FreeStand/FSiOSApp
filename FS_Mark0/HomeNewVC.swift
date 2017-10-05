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
    
    var brandList = [Brand]()
    var selectedBrand: Brand!
    var isBarHidden = true
    
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
    }

    func getBrands() {
        DataService.ds.REF_BRANDS.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let brand = Brand()
                
                let name = snapshot.key
                brand.name = name
            
                if let imgURL = dict["imgURL"] as? String {
                    brand.imgUrl = imgURL
                } else {
                    print("Error: Can't find/cast URL in Brand")
                }
                
                if let totalDeals = dict["totalDeals"] as? Int {
                    brand.totalDeals = totalDeals
                } else {
                    print("Error: Can't find/cast totalDeals in Brand")
                }
                
                self.brandList.append(brand)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.isBarHidden {
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
//            cell.layer.cornerRadius = 15.0
            
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
        performSegue(withIdentifier: "homeToCoupon", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToCoupon" {
            if let vc = segue.destination as? CouponVC {
                vc.brand = selectedBrand
            }
        }
    }

}
