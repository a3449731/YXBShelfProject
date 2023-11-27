//
//  User+Const.swift
//  CUYuYinFang
//
//  Created by 蓝鳍互娱 on 2023/10/11.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import Foundation

class UserConst {
    class var adId: String {
        return UserDefaults.standard.object(forKey: "equipid") as? String ?? ""
    }

    class var token: String {
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJlNGE3Yzk3YjY5ZDk0NmM0YjkzY2U0NDAzNGU5MzcxNiIsImV4cCI6MTcwMTY2ODIyNH0.ssCPUZrX_ZYuVkXih-BgdSBB3IW5aIehjWoq4-ZD16g"
//        return UserDefaults.standard.value(forKey: "UserToken") as? String ?? ""
    }

    class var appversion: String {
        let infoDic = Bundle.main.infoDictionary
        return infoDic?["CFBundleShortVersionString"] as? String ?? ""
    }

    class var platform: String {
        return "1"
    }
        
    class var user: [String: Any] {
        return UserDefaults.standard.object(forKey: "CUYuYinFangUserDic") as? [String: Any] ?? [:]
    }
    
    class var miZuan: String {
        user["miZuan"] as? String ?? ""
    }
    
    class var headImg: String {
        user["headImg"] as? String ?? ""
    }
    
    class var nickName: String {
        user["nickname"] as? String ?? ""
    }
    
    class var uid: String? {
        user["id"] as? String
    }
    
    class var isGh: Bool {
        if let gh = user["isGh"] as? String {
            return gh.bool ?? false            
        }
        return false
    }
}
