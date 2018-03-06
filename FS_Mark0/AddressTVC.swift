//
//  AddressTVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 09/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import SVProgressHUD

class AddressSender {
    public static var sidebar = "sidebar"
    public static var forced = "forced"
}

class AddressTVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AddressViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addressList = [Address]()
    var sender = AddressSender.sidebar
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(Events.SCREEN_ADDRESS_LIST, parameters: nil)
        self.navigationItem.title = "Add/Select Address"        
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
        Analytics.logEvent(Events.ADDRESS_ADD_PRESSED, parameters: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getAddresses() {
        SVProgressHUD.show()
        APIService.shared.fetchAddresses { (response) in
            if response.isEmpty {
                SVProgressHUD.dismiss()
            } else {
                self.addressList = response.addresses!
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
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
        tableView.deselectRow(at: indexPath, animated: true)
        if sender == AddressSender.sidebar {
            Analytics.logEvent(Events.ADDRESS_SEL_SIDEBAR, parameters: nil)
            print("Sidebar")
        } else if sender == AddressSender.forced {
            SVProgressHUD.show()
            Analytics.logEvent(Events.ADDRESS_SEL_ORDER, parameters: nil)
            let address = self.addressList[indexPath.row]
            
            APIService.shared.createNewOrder(nickName: address.nickName!, completionHandler: { (order) in
                SVProgressHUD.dismiss()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC
                vc?.sender = TYSender.addressForced
                vc?.order = order
                self.navigationController?.pushViewController(vc!, animated: true)

            })
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
