//
//  InviteVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 16/10/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseInvites

class InviteVC: UIViewController, InviteDelegate {
    var isGoogleLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for item in providerData {
                if item.providerID == "google.com" {
                    isGoogleLoggedIn = true
                }
            }
            
            if isGoogleLoggedIn == false {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoogleVC") as! GoogleVC
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    @IBAction func inviteTapped(_ sender: AnyObject) {
        if let invite = Invites.inviteDialog() {
            invite.setInviteDelegate(self)
            
            // NOTE: You must have the App Store ID set in your developer console project
            // in order for invitations to successfully be sent.
            
            // A message hint for the dialog. Note this manifests differently depending on the
            // received invitation type. For example, in an email invite this appears as the subject.
            invite.setMessage("Try this out!\n -\(Auth.auth().currentUser?.displayName)")
            // Title for the dialog, this is what the user sees before sending the invites.
            invite.setTitle("You've been invited")
            invite.setDeepLink("app_url")
            invite.setCallToActionText("Install!")
            invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
            invite.open()
        }
    }
    
    func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
        if let error = error {
            print("Failed: " + error.localizedDescription)
        } else {
            print("\(invitationIds.count) invites sent")
        }
    }
}
