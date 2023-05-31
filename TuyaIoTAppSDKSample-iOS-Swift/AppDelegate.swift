//
//  AppDelegate.swift
//  TuyaIoTAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryLinkMQTTPlugin
import TuyaSmartNetworkKit
import IndustryUserImpl
import IndustryLinkSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
             
        IndustryLinkSDK.initialize(withAppKey: AppKey.appKey, appSecret: AppKey.appSecret, clientId: AppKey.clientID, clientSecret: AppKey.clientSecret)
        IndustryLinkSDK.host = AppKey.host;
        
        MQTTBusinessPlugin.initializePlugin()

        #if DEBUG
        IndustryLinkSDK.debugMode = true
        #endif
        
        if #available(iOS 13.0, *) {
            // Will go into scene delegate
            
        } else {
            
            if let isLogin = UserService.shared().user()?.isLogin() {
                print("登录成功：\(isLogin)")
                let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
