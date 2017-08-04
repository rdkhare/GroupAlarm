//
//  AppDelegate.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/10/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "LoginAlarm", bundle: nil)
//        let gettingStoryboard: UIStoryboard = UIStoryboard(name: "GettingStarted", bundle: nil)
        var initialViewController: UIViewController
        if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
            // App already launched
            let userDefault = UserDefaults.standard
            let loggedIn = userDefault.bool(forKey: "loggedIn")
            let createdUsername = userDefault.bool(forKey: "usernameCreated")
            
            if(loggedIn == true && createdUsername == false) {
                initialViewController = (loginStoryboard.instantiateViewController(withIdentifier: "createUsername") as? CreateUsername)!
            }
            else if(loggedIn == true && createdUsername == true) {
                initialViewController = (mainStoryboard.instantiateViewController(withIdentifier: "alarmView") as? AlarmHandler)!
                print("user is already logged in")
            }
            else {
                initialViewController = (loginStoryboard.instantiateViewController(withIdentifier: "loginAlarm") as? LoginAlarm)!
                print("user is not logged in")
            } 
        } else {
            // This is the first launch ever
            
            initialViewController = (loginStoryboard.instantiateViewController(withIdentifier: "loginAlarm") as? LoginAlarm)!
                
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        UIApplication.shared.isStatusBarHidden = true
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

