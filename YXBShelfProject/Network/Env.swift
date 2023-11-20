//
//  ENV.swift
//  MyNetWork
//
//  Created by 杨晓斌 on 2023/7/19.
//

import Foundation

fileprivate let appSetting = "appSetting"

// 区分环境
enum NetworkEnvironment: String {
    case development = "测试环境"
    case stage = "预发环境"
    case release = "生产环境"
}

class Env {
    static let shared = Env()
    
    private let environment: NetworkEnvironment
    // 根据环境，配置不同所需要的网络请求常量配置
    let constants: EnvironmentConfigs
    
    private init() {
#if DEBUG
        self.environment = .development
#elseif STAGING
        self.environment = .stage
#else
        self.environment = .release
#endif
        
        // 根据当前环境初始化 constants 属性，可以从配置文件或其他地方读取环境相关的常量值
        constants = EnvironmentConfigs(env: environment)
    }
}

/// 常量配置
class EnvironmentConfigs {
    // 当前真实所处环境，因为当debug模式下要配合环境切换的能力，这里才是真正的环境。
    var reallyEnv: NetworkEnvironment
    required init(env: NetworkEnvironment) {
        // 解决报错：调用了 fetchRealEnvironment 方法，而在调用该方法时，存储属性 reallyEnv 还没有被初始化。
        self.reallyEnv = env
        self.reallyEnv = self.fetchRealEnvironment(env: env)
    }
    
    // 域名配置
    var baseUrl: String {
        switch reallyEnv {
        case .development: return "https://lanqi.whlqhy.site/test-api"
        case .stage: return "http://192.168.1.44:8082"
        case .release: return "https://lanyu.whlqhy.online/prod-api"
        }
    }
    
    // 其他环境相关的常量属性
    // CDN配置
    var cdnUrl: String {
        switch reallyEnv {
        case .development: return "http://47.104.174.59"
        case .stage: return "http://47.104.174.59"
        case .release: return "http://47.104.174.59"
        }
    }
    
    // IM的appid
    var imAppId: Int {
        switch reallyEnv {
        case .development: return 1400826650
        case .stage: return 1400826650
        case .release: return 1600004379
        }
    }
    
    // 声音回调地址
    var voiceUrl: String {
        "https://lanqi.whlqhy.site/test-api/file_recognition/tFileRecognition/audioStreamCallBackUrl"
    }
    
    // 环境名称
    var title: String {
        self.reallyEnv.rawValue
    }
    
    // 获取到转化后的环境
    private func fetchRealEnvironment(env: NetworkEnvironment) -> NetworkEnvironment {
        switch env {
        case .development:
            // 如果存在本地存储设置。开发环境下优先取本地存储的设置
            if let str = UserDefaults.standard.value(forKey: appSetting) as? String,
               let type = NetworkEnvironment(rawValue: str) {
                return type
            }
            return .development
        case .stage:
            return .stage
        case .release:
            return .release
        }
        return .release
    }
    
    // 设置环境
    func setUserDefaultEnvironment(env: NetworkEnvironment) {
        UserDefaults.standard.set(env.rawValue, forKey: appSetting)
        UserDefaults.standard.synchronize()
    }
}

