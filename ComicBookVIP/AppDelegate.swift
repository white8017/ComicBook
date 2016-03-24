//
//  AppDelegate.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/15.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var orderBookImage = [String:UIImage]()
	var orderBooktTitle=[String]()
	var orderBookNumber = [String:[String]]()
	var canEitting = false
	var bookName = [String]()
    var account = ""
    var phoneNumber = ""
    var vip = ""
    var userDefault = NSUserDefaults.standardUserDefaults() // 就像是在 Android 上的 SharedPreference一樣，暫存於 App 中，直到程式被移除才會消失
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var storedNumber = userDefault.objectForKey("phoneNumber")
        var storedName = userDefault.objectForKey("name")
        

        if storedName != nil {
            account = storedName! as! String
        }

        if storedNumber != nil {
            phoneNumber = storedNumber! as! String
        }
//        print("app:stored = \(storedNumber!)")
//        print(storedName!)
        print("app:name = \(account)")
        print("app:phone = \(phoneNumber)")
        
        // Override point for customization after application launch.
        /* 這裡是電話簡訊驗證 */
        SMSSDK.registerApp("105ec803567da", withSecret: "ac6b27766f62bc57e697711c34a93f32")  //我的
        //            SMSSDK.registerApp("ef0c55d2b850", withSecret: "62f2bf339354b721c1e0e97603630a15")
        // ▴
        
        /* 本地推播註冊 */
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound],
            categories: nil)
        application.registerUserNotificationSettings(settings)
        
        // app 未開啟下推播
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            print((remoteNotification["aps"] as! [NSObject: AnyObject]) ["alert"])
        }
        
        NSThread.sleepForTimeInterval(4)
        
        
        UITabBar.appearance().tintColor = UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
    
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

