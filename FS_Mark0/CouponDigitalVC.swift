//
//  CouponDigitalVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 07/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseAnalytics

class CouponDigitalVC: UIViewController {

    var couponCode: String!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        Analytics.logEvent(Events.SCREEN_COUPON_DETAIL, parameters: nil)
        super.viewDidLoad()
        heightConstraint.constant = self.videoView.frame.width * 1080 / 1440
        playVideo()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: CMTimeMake(5, 10))
                self.player?.play()
            }
        })

        
        doneBtn.layer.cornerRadius = 4
        couponLbl.text = couponCode
    }
    
    @IBAction func copyBtnPressed(_ sender: Any) {
        print("copied")
        Analytics.logEvent(Events.COUPON_COPIED, parameters: nil)
        UIPasteboard.general.string = couponCode
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        Analytics.logEvent(Events.COUPON_DETAIL_DONE, parameters: nil)
        self.navigationController?.popToRootViewController(animated: true)
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
