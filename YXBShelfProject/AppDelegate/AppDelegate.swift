//
//  AppDelegate.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/17.
//

import UIKit
#if DEBUG
import GodEye
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.allApplicationCofing()
        
        self.setupMainViewController()
#if DEBUG
    GodEye.makeEye(with: self.window!)
#endif
                
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
