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
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    //4. - Notification working in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    //5. - Notification tap Action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer {completionHandler()}
        
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        
        let payload = response.notification.request.content
        guard payload.userInfo["beach"] != nil else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "beach")
        
        window?.rootViewController?.present(vc, animated: false)
    }
}
