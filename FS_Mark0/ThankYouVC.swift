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

class ThankYouVC: UIViewController {
    
    enum Notifications: String, NotificationName {
        case phoneAuthVCNotification
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.layer.cornerRadius = 8
        doneBtn.layer.cornerRadius = 18
        
        
        playVideo()
//        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: CMTimeMake(5, 10))
                self.player?.play()
            }
        })

    }
    
    override func viewDidLayoutSubviews() {
        avPlayerLayer.frame = videoView.layer.bounds
    }
    
    func playVideo() {
        print("here")
        guard let path = Bundle.main.path(forResource: "Animation", ofType:"mp4") else {
            debugPrint("Animation.mp4 not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
        
        videoView.layer.addSublayer(avPlayerLayer)
        player.play()
    }


    @IBAction func tyBtnPressed(_ sender: Any?) {
        print("pressed")
        
        let delegateTemp = UIApplication.shared.delegate
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notifications.phoneAuthVCNotification.name, object: nil)
        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//        self.performSegue(withIdentifier: "dobToFeedback", sender: nil)

    }
}
