//
//  My+API.swift
//  CUYuYinFang
//
//  Created by 蓝鳍互娱 on 2023/10/19.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import Moya

enum MyAPI {
    /// 装扮中心列表
    case findZhuangbanProdList(type: Int)
    /// 买装扮
    case userbyZhuangbanPay(zbId: String, subId: String)
    /// 我的背包
    case findMyZbList(type: Int)
    /// 佩戴装扮
    case userUsedZb(zbId: String, type: Int)
    /// 取消装扮
    case cancelUserUsedZb(zbId: String, type: Int)
}

extension MyAPI: APIService {
    var route: APIRoute {
        switch self {
            case .findZhuangbanProdList: return .post("/api/v1/findZhuangbanProdList")
            case .userbyZhuangbanPay: return .post("/api/v1/userbyZhuangbanPay")
            case .findMyZbList: return .post("/api/v1/findMyZbList")
            case .userUsedZb: return .post("/api/v1/userUsedZb")
            case .cancelUserUsedZb: return .post("/api/v1/cancelUserUsedZb")
        }
    }
    
    var parameters: APIParameters? {
        // 需要的参数和，解析方法，解析方式可以为空。
        typealias PE = (parameters: [String: Any], encoding: ParameterEncoding?)
        var result: PE = ([:], nil)
        
        switch self {
        case let .findZhuangbanProdList(type):
            result.parameters = ["type": String(type)]
            
        case let .userbyZhuangbanPay(zbId, subId):
            result.parameters = ["zbId": zbId,
                                 "subId": subId]
            
        case let .findMyZbList(type):
            result.parameters = ["type": String(type)]
            
        case let .userUsedZb(zbId, type):
            result.parameters = ["id": zbId,
                                 "type": type]
            
        case let .cancelUserUsedZb(zbId, type):
            result.parameters = ["id": zbId,
                                 "type": type]
            
        default:
            return nil
        }
        return APIParameters(values: result.parameters, encoding: result.encoding)
    }
}
