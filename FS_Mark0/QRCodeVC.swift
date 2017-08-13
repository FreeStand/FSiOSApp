//
//  QRCodeVC.swift
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

class QRCodeVC: UIViewController, QRCodeReaderViewControllerDelegate {
    
    var qrcodeRef: DatabaseReference!
    @IBOutlet weak var previewView: UIView!
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
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
            self.checkForDuplicateScan(qrCode: result.value)
        }
    }
    
    let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)

    func checkForDuplicateScan(qrCode: String) {
        DataService.ds.REF_USER_CURRENT.child("orders").observe(.value, with: { (snapshot) in
            if snapshot.hasChild(qrCode) {
                print("Already Scanned")
                let alert = UIAlertController(title: "Already Redeemed", message: "This offer has already been redeemed by you. Stay tuned.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.tabBarController?.selectedIndex = 0
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("New Scan")
                self.updateQRCode(qrCode: qrCode)
            }
        })
    }
    
    
    func updateQRCode(qrCode: String) {
        print(qrCode)
        var data = ["uid": KeychainWrapper.standard.string(forKey: "KEY_UID"),
                    "boxID": qrCode,
                    "time": timestamp
        ]
        
        var childValues = ["\(qrCode)":data]
        DataService.ds.REF_BOX.updateChildValues(childValues)
        
        
        data = ["boxID": qrCode,
                "time": timestamp
        ]
        childValues = ["\(qrCode)":data]
        
        DataService.ds.REF_USER_CURRENT.child("orders").updateChildValues(childValues)
        
        
        performSegue(withIdentifier: "QRToThankYou", sender: nil)
        // Place code here for Thank You View
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
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
