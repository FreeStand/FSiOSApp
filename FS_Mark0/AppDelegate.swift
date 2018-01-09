//
//  AppDelegate.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 26/06/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, GIDSignInDelegate {
    
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().barTintColor = UIColor().HexToColor(hexString: "#000000", alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent

        
        let userDefaults = UserDefaults.standard
//        if let isLogin = userDefaults.value(forKey: "isLoggedIn") as! Bool? {
//            if (isLogin == false) {
//                print("1")
//                self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SIgnInVC")
//            } else {
//                print("2")
//                self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//            }
//        } else {
//            print("3")
//
//            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SIgnInVC")
//        }
        
        

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
//    override init() {
//        FirebaseApp.configure()
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Did Fail to Register for Remote Notifications")
        print("\(error), \(error.localizedDescription)")
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let appID = FBSDKSettings.appID()
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appID!)") && url.host ==  "authorize" {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        } else if url.scheme != nil && url.scheme!.hasPrefix("com.googleusercontent.apps.225537858800-4happep34rf0tsiusi30vr0jh92c0ijn") && url.host ==  "authorize" {
            print("here now")
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
        }
        
        return self.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "" )
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let invite = Invites.handle(url, sourceApplication:sourceApplication, annotation:annotation) as? ReceivedInvite {
            let matchType =
                (invite.matchType == .weak) ? "Weak" : "Strong"
            print("Invite received from: \(sourceApplication ?? "") Deeplink: \(invite.deepLink)," +
                "Id: \(invite.inviteId), Type: \(matchType)")
            return true
        }
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFCM()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    

    @objc func tokenRefreshNotification(notification: NSNotification ) {
        let refreshedToken = InstanceID.instanceID().token()
        print("InstanceID token: \(String(describing: refreshedToken))")
        connectToFCM()
    }
    
    func connectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        print("connected to FCM")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        

        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().currentUser?.link(with: credential, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.window?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            } else {
                UserDefaults.standard.set("true", forKey: "isGoogleSignedIn")
                print("Google Auth successful in Firebase")
                DataService.ds.updateFirebaseDBUserWithUserData(userData: [[ "isGoogleSignedIn" : "true" as AnyObject]])
                self.window?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

