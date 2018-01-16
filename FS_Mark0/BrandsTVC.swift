//
//  BrandsTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class BrandsTVC: UITableViewController {
    
    var brandList = [Brand]()
    var selectedBrand: Brand!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Coupons"
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        getBrands()
    }

    func getBrands() {
        print("called")
        DataService.ds.REF_BRANDS.observe(.childAdded, with:  { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let brand = Brand()
                brand.name = snapshot.key
                
                if let imgURL = dict["imgURL"] as? String {
                    brand.imgUrl = imgURL
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
                }
            } else {
                print("Error: Can't cast dict from snapshot in Brands")
            }
        }) { (error) in
            print("Error: Can't load Brands from Brands DB")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return brandList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as? BrandCell {
            cell.contentView.addBottomBorderWithColor(color: UIColor().HexToColor(hexString: "#111218", alpha: 1.0), width: 2.0)
            cell.clipsToBounds = true
            
            let brand: Brand!
            brand = brandList[indexPath.row]
            cell.configureCell(brand: brand)
            
            return cell
        }
        return UITableViewCell()
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("BrandCell")
        selectedBrand = brandList[indexPath.row]
        if selectedBrand.coupons != nil {
            performSegue(withIdentifier: "BrandToCoupon", sender: nil)
        }
    }
    
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BrandToCoupon" {
            if let vc = segue.destination as? NewCouponVC {
                vc.brand = self.selectedBrand
            }
        }
    }
    

}
