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

class TYSender {
    public static var addressForced = "addressForced"
    public static var others = "others"
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
            addressLabel.text = "Your box will be delivered to:\n \(self.address.addressLine1!)\n\(self.address.addressLine2!)\n\(self.address.city!)\n\(self.address.pincode!)\n\(self.address.state!)"
        }
        
        let swipeButtonRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ThankYouVC.buttonRight))
        swipeButtonRight.direction = UISwipeGestureRecognizerDirection.right
        self.doneView.addGestureRecognizer(swipeButtonRight)


    }
    
    @objc func buttonRight() {
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
