//
//  CouponDetailVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 04/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import SwiftyGif

class CouponDetailVC: UIViewController {
    @IBOutlet weak var codeImg: UIImageView!
    
    var couponCode: String!

    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 10
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY - 100), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY - 100), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-125, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        view.addSubview(timeLabel)
    }

    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
        } else {
            timeLabel.text = "00:00"
            timer.invalidate()
           
            let  vc =  self.navigationController?.viewControllers[0]
            navigationController?.popToViewController(vc!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeImg.downloadedFrom(link: couponCode)
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = 10
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                
        self.navigationItem.title = "Coupon"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

    }
    
    @objc func back(sender: UIBarButtonItem) {
        let  vc =  self.navigationController?.viewControllers[0]
        navigationController?.popToViewController(vc!, animated: true)

    }
}


