//
//  AddressCVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 02/02/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class AddressCVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var addressList = [Address]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib.init(nibName: "AddressCell", bundle: nil), forCellWithReuseIdentifier: "AddressCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        getAddresses()
    }

    func getAddresses() {
        DataService.ds.REF_USER_CURRENT.child("addresses").observeSingleEvent(of: .value) { (snapshot) in
            if let addressArray = snapshot.value as? [[String:String]] {
                for anAddress in addressArray {
                    let address = Address()
                    if let nickName = anAddress["nickName"] {
                        address.nickName = nickName
                    } else {
                        print("Error: Can't cast nickName in Address")
                    }
                    if let address1 = anAddress["addressLine1"] {
                        address.address1 = address1
                    } else {
                        print("Error: Can't cast address1 in Address")
                    }
                    if let address2 = anAddress["addressLine2"] {
                        address.address2 = address2
                    } else {
                        print("Error: Can't cast address2 in Address")
                    }
                    if let city = anAddress["city"] {
                        address.city = city
                    } else {
                        print("Error: Can't cast city in Address")
                    }
                    if let state = anAddress["state"] {
                        address.state = state
                    } else {
                        print("Error: Can't cast state in Address")
                    }
                    if let pincode = anAddress["pincode"] {
                        address.pincode = pincode
                    } else {
                        print("Error: Can't cast pincode in Address")
                    }
                    self.addressList.append(address)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                print("Error: Can't cast addressArray in Addresses")
            }
        }
    }
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressCell", for: indexPath) as? AddressCell {
//                print("Aryan: \(indexPath.)")
                let address: Address!
                address = addressList[indexPath.row]
                cell.configureCell(address: address)
                return cell
            }

        } else if indexPath.section == 1 {
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "plusCell", for: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return addressList.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

}
