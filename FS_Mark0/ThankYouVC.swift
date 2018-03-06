//
//  ThankYouVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 08/08/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseAnalytics
import SAConfettiView

class TYSender {
    public static var addressForced = "addressForced"
    public static var postSampling = "postSampling"
    public static var qr = "qr"
}

class ThankYouVC: UIViewController {
    
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var al1Lbl: UILabel!
    @IBOutlet weak var al2Lbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var pincodeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var deliveryAddressLbl: UILabel!

    
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var confView: UIView!
    @IBOutlet weak var tyLbl: UILabel!
    var order: Order!
    var sender: String!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(Events.SCREEN_THANK_YOU, parameters: nil)
        let confettiView = SAConfettiView(frame: self.confView.bounds)
        confettiView.type = .Confetti
        self.confView.addSubview(confettiView)
        confView.sendSubview(toBack: confettiView)
        confettiView.startConfetti()

        if sender! == TYSender.addressForced {
            Analytics.logEvent(Events.THANK_YOU_ONLINE_PRE, parameters: nil)
            tyLbl.text = "Order Placed!!"
            orderIDLbl.text = "OrderID: " + order.orderID!
            nameLbl.text = order.name!
            al1Lbl.text = order.addressLine1!
            al2Lbl.text = order.addressLine2!
            cityLbl.text = order.city!
            stateLbl.text = order.state!
            pincodeLbl.text = order.pincode!
            
        } else if sender! == TYSender.qr {
            Analytics.logEvent(Events.THANK_YOU_QR, parameters: nil)
            tyLbl.text = "Show this screen to the Free Stand volunteer & collect your box."
            tyLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            orderIDLbl.isHidden = true
            nameLbl.isHidden = true
            al1Lbl.isHidden = true
            al2Lbl.isHidden = true
            cityLbl.isHidden = true
            stateLbl.isHidden = true
            pincodeLbl.isHidden = true
            deliveryAddressLbl.isHidden = true

        } else if sender! == TYSender.postSampling {
            Analytics.logEvent(Events.THANK_YOU_POST, parameters: nil)
            tyLbl.text = "Thank you for taking."
            tyLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            orderIDLbl.isHidden = true
            nameLbl.isHidden = true
            al1Lbl.isHidden = true
            al2Lbl.isHidden = true
            cityLbl.isHidden = true
            stateLbl.isHidden = true
            pincodeLbl.isHidden = true
            deliveryAddressLbl.isHidden = true

        }
        
        
        let swipeButtonRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ThankYouVC.buttonRight))
        swipeButtonRight.direction = UISwipeGestureRecognizerDirection.right
        self.doneView.addGestureRecognizer(swipeButtonRight)


    }
    
    @objc func buttonRight() {
        Analytics.logEvent(Events.THANK_YOU_DONE_SWIPE, parameters: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }

}
