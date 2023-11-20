//
//  LQNetWorkHostUrl.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/18.
//

import Foundation

enum NetWorkType: Int {
    /// 测试
    case test = 1
    /// 预发
    case stage
    /// 线上
    case release
    /// RAP环境
    case rap
    
    // 环境名称
    var environmentString: String {
        switch self {
        case .test: "测试环境"
        case .stage: "预发环境"
        case .release: "线上环境"
        case .rap: "RAP环境"
        }
    }
    
    // 配置服务器地址
    var environmentHostUrl: String {
        switch self {
        case .test: "https://lanqi.whlqhy.site/test-api"
        case .stage: "http://192.168.1.44:8082"
        case .release: "https://lanyu.whlqhy.online/prod-api"
        case .rap: "https://lanyu.whlqhy.online/prod-api"
        }
    }
}

class LQNetWorkHostUrl {
    
    // 获取当前 地址
    static func currentHost() -> String {
        let type = NetWorkType(rawValue: UserDefaults.standard.integer(forKey: "appSetting"))
        return selectHost(with: type)
    }
    
    // 获取指定环境地址
    static func selectHost(with type: NetWorkType?) -> String {
        type?.environmentHostUrl ?? NetWorkType.release.environmentHostUrl
    }
    
    /// 设置默认的开发环境
    static func setDefaultstNetWorkBaseURL(with type: NetWorkType) {
        UserDefaults.standard.set(type.rawValue, forKey: "appSetting")
        UserDefaults.standard.synchronize()
    }
    
    /// 设置接口，根据环境。
    /// 如果设置过默认的环境，会优先取设置过的值。 配合DebugToolKit切换网络环境 ( ***** 注意仅在开发环境下可以切换 ******)
    /// @param isDevelop 0, 1, 2 .  0: 开发环境   1：预发环境     2：线上环境
    static func setHostURL(isDevelop: Int) -> String {
        var type = NetWorkType.release
        if isDevelop == 0 {
            type = NetWorkType(rawValue: UserDefaults.standard.integer(forKey: "appSetting"))!
            if type == .test {
                setDefaultstNetWorkBaseURL(with: type)
            }
        } else if isDevelop == 1 {
            type = .stage
            setDefaultstNetWorkBaseURL(with: type)
        } else {
            setDefaultstNetWorkBaseURL(with: NetWorkType.release)
        }
        return selectHost(with: type)
    }
    
    // 获取环境名称
    static func currentNetworkEnvironment() -> String {
        let type = NetWorkType(rawValue: UserDefaults.standard.integer(forKey: "appSetting"))
        return type?.environmentString ?? "未知环境"
    }
    
    // 其他配置 -- 照着写就行了
    static func currentCDNPictureHost() -> String {
        let type = NetWorkType(rawValue: UserDefaults.standard.integer(forKey: "appSetting"))
        return selectCDNPictureHost(with: type)
    }
    
    static func selectCDNPictureHost(with type: NetWorkType?) -> String {
        switch type {
        case .test:
            return "http://47.104.174.59"
        case .stage:
            return "http://47.104.174.59"
        case .release:
            return "http://47.104.174.59"
        default:
            return "http://47.104.174.59"
        }
    }
    
    static func currentImKey() -> Int {
        let type = NetWorkType(rawValue: UserDefaults.standard.integer(forKey: "appSetting"))
        return setDefaultstIM(with: type)
    }
    
    static func setDefaultstIM(with type: NetWorkType?) -> Int {
        switch type {
        case .test:
            return 1400826650
        case .stage:
            return 1400826650
        case .release:
            return 1600004379
        default:
            return 1600004379
        }
    }
    
    static func currentVoiceBackShuMei() -> String {
        let type = NetWorkType(rawValue: UserDefaults.standard.integer(forKey: "appSetting"))
        return selectVoiceBack(with: type)
    }
    
    static func selectVoiceBack(with type: NetWorkType?) -> String {
        switch type {
        case .test:
            return "https://lanqi.whlqhy.site/test-api/file_recognition/tFileRecognition/audioStreamCallBackUrl"
        case .stage:
            return "https://lanqi.whlqhy.site/test-api/file_recognition/tFileRecognition/audioStreamCallBackUrl"
        case .release:
            return "https://lanqi.whlqhy.site/test-api/file_recognition/tFileRecognition/audioStreamCallBackUrl"
        default:
            return "https://lanqi.whlqhy.site/test-api/file_recognition/tFileRecognition/audioStreamCallBackUrl"
        }
    }
}
