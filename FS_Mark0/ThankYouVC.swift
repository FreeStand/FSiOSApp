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

class TYSender {
    public static var addressForced = "addressForced"
    public static var postSampling = "postSampling"
    public static var qr = "qr"
}

class ThankYouVC: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneView: UIView!
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    var sender: String!
    var address: Address!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(Events.SCREEN_THANK_YOU, parameters: nil)
//        videoView.layer.cornerRadius = 2
        addressLabel.layer.cornerRadius = 2
        heightConstraint.constant = self.videoView.frame.width * 1080 / 1440

        playVideo()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: CMTimeMake(5, 10))
                self.player?.play()
            }
        })
        
        if sender! == TYSender.addressForced {
            Analytics.logEvent(Events.THANK_YOU_ONLINE_PRE, parameters: nil)
            addressLabel.text = "Your box will be delivered to:\n \(self.address.addressLine1!)\n\(self.address.addressLine2!)\n\(self.address.city!)\n\(self.address.pincode!)\n\(self.address.state!)"
        } else if sender! == TYSender.qr {
            Analytics.logEvent(Events.THANK_YOU_QR, parameters: nil)
        } else if sender! == TYSender.postSampling {
            Analytics.logEvent(Events.THANK_YOU_POST, parameters: nil)
        }
        
        
        let swipeButtonRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ThankYouVC.buttonRight))
        swipeButtonRight.direction = UISwipeGestureRecognizerDirection.right
        self.doneView.addGestureRecognizer(swipeButtonRight)


    }
    
    @objc func buttonRight() {
        Analytics.logEvent(Events.THANK_YOU_DONE_SWIPE, parameters: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }

    override func viewDidLayoutSubviews() {
        avPlayerLayer.frame = videoView.layer.bounds
    }
    
    func playVideo() {
        print("here")
        guard let path = Bundle.main.path(forResource: "Animation_2x", ofType:"mp4") else {
            debugPrint("Animation.mp4 not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
        
        videoView.layer.addSublayer(avPlayerLayer)
        player.play()
    }

}
