//
//  LogCustomPlugin.swift
//  YXBSwiftProject
//
//  Created by yangxiaobin on 2023/10/8.
//  Copyright © 2023 ShengChang. All rights reserved.
//

import Moya

struct LogCustomPlugin: PluginType {
    
//    func willSend(_ request: RequestType, target: TargetType) {
//        if let api = target as? APIService {
//            debugPrint(api.url ,api.parameters?.values)
//        }
//    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if let api = target as? APIService {
            let str = """
            
            ------------------------------------------
            \(cureentTimeString())
            🦁请求接口: \(api.url.absoluteString)
            """
            print(str)
            
            
            if let parameter = api.parameters?.values {
                print("请求参数:", parameter)
            }
            switch result {
            case .success(let response):
//                print("请求头到底有什么" ,response.request?.headers)
                
                let adjustData = responseLoggingDataFormatter(response.data)
                let str = """
                🦐响应数据: \((String(data: adjustData, encoding: .utf8) ?? ""))
                -----------------------------------------------------
                
                """
                print(str)
            case .failure(let error):
                print("❌ 报错了", api.url.absoluteString, error)
            }
        }
    }
    
    // 获取时间
    func cureentTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())
        return timestamp
    }
    
    // 调整响应的数据格式，为了让参数更好看，像Json一样有格式的展示
    func responseLoggingDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    }
}
