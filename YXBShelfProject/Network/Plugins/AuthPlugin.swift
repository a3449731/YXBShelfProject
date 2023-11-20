//
//  AuthPlugin.swift
//  MyNetWork
//
//  Created by 杨晓斌 on 2023/7/19.
//

import Moya


struct AuthPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue(UserConst.token, forHTTPHeaderField: "apptoken")
        request.addValue(UserConst.adId, forHTTPHeaderField: "sensorNo")
        request.addValue(UserConst.appversion, forHTTPHeaderField: "version")
        request.addValue(UserConst.platform, forHTTPHeaderField: "platform")
        return request
    }
    
    // 这里主要是 单独处理一下401的， token过期逻辑
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if let api = target as? APIService {
            switch result {
            case .success(let response):
                do {
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        if let code = json["code"] as? Int,
                           String(code) == "401" {
//                            MyTool.logoutLogin()
                        }
                    }
                } catch {
                    
                }
            default:
                return
            }
        }
    }
}
