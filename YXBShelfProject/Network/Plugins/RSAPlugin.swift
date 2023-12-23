//
//  RSAPlugin.swift
//  CUYuYinFang
//
//  Created by yangxiaobin on 2023/10/21.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import Moya

/// 这个还没有试验成功，是个失败品。
struct RSAPlugin: PluginType {
    // 要在这里面对 入参进行rsa加密
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard let data = request.httpBody else {
            return request
        }
        let prama = IPNRSAUtil.signAndSecret(["zbId": "54a6d28eec1c4c9f8c8192368e58ece4",
                                              "subId": "cbe695f55f724782987dfd12b7f091e4"])
        let encryptedData = prama?.jsonData()
        
        debugPrint("加密", prama, encryptedData)
        var updatedRequest = request
        updatedRequest.httpBody = encryptedData
        
        return request
    }
}
