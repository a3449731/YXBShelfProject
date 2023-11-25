//
//  AppDelegate+DBDebugTool.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/18.
//

import Foundation
/*
#if DEBUG
import DBDebugToolkit
#endif

extension AppDelegate {
    func setupDebugTool() {
#if DEBUG
        DBDebugToolkit.setup()
        self.addTestCustomAction()
#endif
    }
    
#if DEBUG
    private func addTestCustomAction() {
        let envConfigs = Env.shared.constants
        
        let actionCurrent = DBCustomAction(name: "当前环境为：👉\(envConfigs.title)👈", body: nil)
        DBDebugToolkit.add(actionCurrent)
        
        let actionTest = DBCustomAction(name: "切换为测试环境", body: { [weak self] in
            envConfigs.setUserDefaultEnvironment(env: .development)
            self?.removeIMSig()
            exit(0)
        })
        DBDebugToolkit.add(actionTest)
        
        let actionRelease = DBCustomAction(name: "切换为预发环境", body: { [weak self] in
            envConfigs.setUserDefaultEnvironment(env: .stage)
            self?.removeIMSig()
            exit(0)
        })
        DBDebugToolkit.add(actionRelease)
        
        let actionOnline = DBCustomAction(name: "切换为线上环境", body: { [weak self] in
            envConfigs.setUserDefaultEnvironment(env: .release)
            self?.removeIMSig()
            exit(0)
        })
        DBDebugToolkit.add(actionOnline) 
    }
    
    private func removeIMSig() {
        // let defaults = UserDefaults.standard
        // defaults.removeObject(forKey: Key_UserInfo_Appid)
        // defaults.removeObject(forKey: Key_UserInfo_Sig)
        // defaults.synchronize()
        // let manage = GJYWXManager()
        // manage.removeCert()
    }
    
#endif
    
}
*/
