//
//  AddressTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 09/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class AddressSender {
    public static var sidebar = "sidebar"
    public static var forced = "forced"
}

class AddressTVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AddressViewControllerDelegate {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var addressList = [Address]()
    var sender = AddressSender.sidebar
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Addresses"        
        backgroundImg.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        getAddresses()
        self.tableView.tableFooterView = UIView()
        
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "icAddCircleWhite"), for: .normal)
        addBtn.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        let addItem = UIBarButtonItem(customView: addBtn)
        self.navigationItem.setRightBarButton(addItem, animated: true)
    }

    @objc func addAddress() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getAddresses() {
        Alamofire.request(APIEndpoints.addressEndpoint).responseJSON { (res) in
            if let result = res.result.value as? NSDictionary {
                if let isEmpty = result["isEmpty"] as? Bool {
                    if !isEmpty{
                        if let addresses = result["addresses"] as? [[String:String]] {
                            for anAddress in addresses {
                                let address = Address()
                                
                                if let addressLine1 = anAddress["addressLine1"] {
                                    address.addressLine1 = addressLine1
                                } else {
                                    print("Error: Can't get addressLine1 from addresses in AddressTVC")
                                }
                                
                                if let addressLine2 = anAddress["addressLine2"] {
                                    address.addressLine2 = addressLine2
                                } else {
                                    print("Error: Can't get addressLine2 from addresses in AddressTVC")
                                }
                                
                                if let city = anAddress["city"] {
                                    address.city = city
                                } else {
                                    print("Error: Can't get city from addresses in AddressTVC")
                                }
                                
                                if let state = anAddress["state"] {
                                    address.state = state
                                } else {
                                    print("Error: Can't get state from addresses in AddressTVC")
                                }

                                if let pincode = anAddress["pincode"] {
                                    address.pincode = pincode
                                } else {
                                    print("Error: Can't get pincode from addresses in AddressTVC")
                                }
                                
                                if let nickname = anAddress["nickName"] {
                                    address.nickname = nickname
                                } else {
                                    print("Error: Can't get nickname from addresses in AddressTVC")
                                }

                                self.addressList.append(address)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }

                            }
                        } else {
                            print("Error: Can't get addresses in AddressTVC")
                        }
                    }
                } else {
                    print("Error: Can't get isEmpty in addresses in AddressTVC")
                }
            } else {
                print("Error: Can't cast result in AddressTVC")
            }
        }
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sender == AddressSender.forced {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC
            present(vc!, animated: true, completion: nil)
        } else if sender == AddressSender.sidebar {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell {
            
            let address: Address!
            address = addressList[indexPath.row]
            cell.configureCell(address: address)
            return cell
        }
        return UITableViewCell()
    }
    
    func addressViewControllerResponse(address: Address) {
        addressList.append(address)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

}
