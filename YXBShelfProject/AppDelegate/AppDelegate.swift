//
//  AppDelegate.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.allApplicationCofing()
        
        self.setupMainViewController()
                
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
    
    func allApplicationCofing() -> Void {
//        self.setupDebugTool()
        self.setupSDWebImage()
        self.setupLogConfig()                
    }
    
    func setupMainViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let loginVc = ExampleViewController.init()
        let nav = UINavigationController.init(rootViewController: loginVc)
        self.window?.rootViewController = nav;
        self.window?.makeKeyAndVisible()
    }
}
