//
//  QRScanVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 11/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import AVFoundation
import UIKit
import QRCodeReader
import FirebaseDatabase
import FirebaseAnalytics
import SwiftKeychainWrapper
import FirebaseAuth
import Alamofire
import SideMenu


class QRScanVC: UIViewController, QRCodeReaderViewControllerDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewView: UIView!
    
    var collegeList = [College]()
    var filteredCollegeList = [College]()
    
    var qrcodeRef: DatabaseReference!
    var surveyID: String!
    var locationID: String!
    var category: String!
    var quesArray: NSArray!
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sideMenuNC = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideMenuNC
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.35
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.90
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.fiBlack
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        SideMenuManager.default.menuWidth = 220
        
        previewView.layer.cornerRadius = 10
        Analytics.logEvent(Events.SCREEN_QR, parameters: nil)
        self.navigationItem.title = "Scan QR Here"
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        getColleges()
        scanInPreviewAction()
    }
    
    func getColleges() {
        Alamofire.request(APIEndpoints.collegeListEndpoint).responseJSON { (res) in
            guard let data = res.data else { return }
            do {
                let colleges = try JSONDecoder().decode([College].self, from: data)
                print(colleges)
                self.collegeList = colleges
            } catch {
                print(error)
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        scanInPreviewAction()
    }
    
    
    func scanInPreviewAction() {
        guard checkScanPermissions(), !reader.isRunning else { return }
        
        reader.previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(reader.previewLayer)
        
        reader.startScanning()
        reader.didFindCode = { result in
            let res = result.value
            var index = res.index(res.startIndex, offsetBy: 5)
            self.surveyID = String(res[..<index])
            self.category = String(res[index])
            index = res.index(res.startIndex, offsetBy: 6)
            self.locationID = String(res[index...])
            self.checkQR()
        }
    }
    
    let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
    
    
    func checkQR() {
        if category == "G" {
            category = "General"
        } else if category == "S"{
            let gender = UserDefaults.standard.string(forKey: "userGender")
            category = gender
        }
        let url = "\(APIEndpoints.checkQREndpoint)?uid=\(UserInfo.uid!)&lid=\(self.locationID!)&sid=\(self.surveyID!)&category=\(self.category!)"
        print(url)
        Alamofire.request(url).responseJSON { (res) in
            let response = res.result.value as? NSDictionary
            if let status = response!["status"] as? String {
                if status == "valid" {
                    let dict = response!["dict"] as! NSDictionary
                    Analytics.logEvent(Events.QR_SUCC, parameters: nil)
                    self.quesArray = dict["questions"] as? NSArray
                    self.surveyID = dict["surveyID"] as? String
                    self.handleValid()
                } else if status == "invalid" {
                    Analytics.logEvent(Events.QR_INVALID, parameters: nil)
                    self.makeAlert("Invalid Code Scanned", message: "The code scanned by you is invalid.")
                } else if status == "duplicate" {
                    self.makeAlert("Already Redeemed", message: "You have already redeemed this offer. Stay tuned for more")
                    Analytics.logEvent(Events.QR_DUPL, parameters: nil)
                }
            }
        }
    }
    
    func handleValid() {
        let lower = self.locationID!.lowercased()
        filteredCollegeList = collegeList.filter({ (college: College) -> Bool in
            return (college.abbreviation?.lowercased().contains(lower))!
        })
        
        let college = filteredCollegeList[0]
        
        let alert = UIAlertController(title: title, message: "Do you study at \(college.name!)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (alert) in
            Analytics.logEvent(Events.QR_COLLEGE_SAME, parameters: nil)
            DataService.ds.REF_USER_CURRENT.updateChildValues(["college": college.name!])
            DataService.ds.REF_COLLEGES.child(self.locationID).child("users").updateChildValues([(Auth.auth().currentUser?.uid)!:true])
            let FeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
            FeedbackVC?.sender = FeedbackSender.eventQR
            FeedbackVC?.quesArray = self.quesArray
            FeedbackVC?.surveyID = self.surveyID
            self.navigationController?.pushViewController(FeedbackVC!, animated: true)

        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (alert) in
            Analytics.logEvent(Events.QR_COLLEGE_DIFF, parameters: nil)
            let CollegeTVC = self.storyboard?.instantiateViewController(withIdentifier: "CollegeTVC") as? CollegeTVC
            CollegeTVC?.surveyID = self.surveyID
            CollegeTVC?.quesArray = self.quesArray
            CollegeTVC?.collegeList = self.collegeList
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

            self.navigationController?.pushViewController(CollegeTVC!, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateQRCode(qrCode: String) {
        DataService.ds.updateFirebaseDBUserWithQR(userData: [["\(qrCode)": "true" as AnyObject]])
        DataService.ds.REF_COLLEGES.child(qrCode).child("users").updateChildValues([(Auth.auth().currentUser?.uid)!:true])
        self.activityIndicator.stopAnimating()
        
        let FeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedbackVC") as? FeedbackVC
        FeedbackVC?.sender = "InitialQR"
        FeedbackVC?.surveyID = self.surveyID
        FeedbackVC?.quesArray = self.quesArray
        self.present(FeedbackVC!, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController?
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert?.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(settingsURL)
                            }
                        }
                    }
                }))
                
                alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            case -11814:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            default:
                alert = nil
            }
            
            guard let vc = alert else { return false }
            
            present(vc, animated: true, completion: nil)
            
            return false
        }
    }
    
    
    // MARK: - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        
        print("reader called")
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
            self.scanInPreviewAction()
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func sideMenuPressed(_ sender: Any) {
        Analytics.logEvent(Events.SIDEBAR_TAPPED, parameters: nil)
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    
}


