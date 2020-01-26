//
//  AppDelegate.swift
//  PushNotifications
//
//  Created by Ygor Nascimento on 26/01/20.
//  Copyright © 2020 Ygor Nascimento. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //1. - Asking for user permission on app start
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
            guard granted else { return }
            
            //2. - If the permission was "granted", we register the app with the APN
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        return true
    }
    
    //3. - Getting the device token from APN
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") {$0 + String(format: "%02x", $1)}
        print("Device token: \(token)")
    }
}
