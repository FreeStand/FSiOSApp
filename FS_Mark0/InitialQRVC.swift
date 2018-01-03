//
//  InitialQRVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 26/06/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import AVFoundation
import UIKit
import QRCodeReader
import FirebaseDatabase
import SwiftKeychainWrapper
import FirebaseAuth

class InitialQRVC: UIViewController, QRCodeReaderViewControllerDelegate {
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var qrcodeRef: DatabaseReference!
    @IBOutlet weak var previewView: UIView!
    
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
        previewView.layer.cornerRadius = 10
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewView.addSubview(blurEffectView)
        previewView.sendSubview(toBack: view)
        
        scanInPreviewAction()
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
            self.checkValidCode(qrCode: result.value)
            print(result.value)
            //            self.checkForDuplicateScan(code: result.value)
        }
    }
    
    let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
    
    func checkForDuplicateScan(code: String) {
        activityIndicator.startAnimating()
        DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("samples") {
                self.activityIndicator.stopAnimating()
                print("Error: Already Redeemed")
                let alert = UIAlertController(title: "Already Redeemed", message: "Only 1 box per user. Stay tuned.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.scanInPreviewAction()
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.updateQRCode(qrCode: code)
                //                self.checkValidCode(qrCode: code)
            }
        }) { (error) in
            print("Error: \(error.localizedDescription)")
            self.activityIndicator.stopAnimating()
        }
    }
    
    func checkValidCode(qrCode: String) {
        DataService.ds.REF_COLLEGES.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild(qrCode) {
                print("Valid Code")
                //                self.updateQRCode(qrCode: qrCode)
                self.checkForDuplicateScan(code: qrCode)
            } else {
                self.activityIndicator.stopAnimating()
                print("Invalid Code")
                let alert = UIAlertController(title: "Invalid Code Scanned", message: "The code scanned by you is invalid.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.scanInPreviewAction()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }) { (error) in
            self.activityIndicator.stopAnimating()
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func updateQRCode(qrCode: String) {
        DataService.ds.updateFirebaseDBUserWithQR(userData: [["\(qrCode)": "true" as AnyObject]])
        DataService.ds.REF_COLLEGES.child(qrCode).child("users").updateChildValues([(Auth.auth().currentUser?.uid)!:true])
        self.activityIndicator.stopAnimating()
        
//        self.dismiss(animated: true, completion: nil)
//        NotificationCenter.default.post(name: Notifications.phoneAuthVCNotification.name, object: nil)
        performSegue(withIdentifier: "initialQrToThankYou", sender: nil)
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
}

