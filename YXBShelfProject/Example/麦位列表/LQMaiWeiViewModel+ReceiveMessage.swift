//
//  LQMaiWeiViewModel+ReceiveMessage.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/25.
//

import Foundation
import SwiftyJSON
import HandyJSON

// 收到消息
extension LQMaiWeiViewModel {
    
    /// 收到全麦List的消息推送, 重置全麦数据重新配置. 有一个很恶心的事情：9人的房的房主跟着列表一起推送过来了， 而5人房不推房主
    //    200：上麦，下麦，跳麦 以后都会收到服务器那边推来的麦位信息, 204,收到当前麦位状态推送，另外接口请求的数据结构也与这一模一样。
    @objc func receiveAllMaiListMessage(text: String) {
        let json = JSON(parseJSON: text)
        let biList = json["biList"].arrayValue
        let suoList = json["suoList"].arrayValue
        let maiweiNameList = json["maiweiNameList"].arrayValue
        
        // 数据全部重置为新的数据
        var modelArray = self.creatMaiWei(count: 8)
        
        // 把dataList转成 [LQMaiWeiModel]的数组，用HandyJSON解析
        let dataListString = json["dataList"].rawString()
        if let maiweiArray = [LQMaiWeiModel].deserialize(from: dataListString) as? [LQMaiWeiModel],
           maiweiArray.count != 0 {
            
            maiweiArray.forEach { model in
                // 通过麦位号进行数据替换
                if let index = self.findIndex(array: modelArray, mai: model.mai) {
                    modelArray[index] = model
                }
                
                // 如果有mai为0的，那是房主的的麦位，需要单独处理
                // 另外只有在9人房才会在这里出现主持麦的信息，5人房不会在这里，是自己合成的。
                if let mai = model.mai,
                   mai == .host {
                    self.receiveHostMaiMessage(model: model)
                }
            }
        }
        
        // 遍历闭麦数组
        biList.forEach { json in
            if let mai = json.string,
               let index = self.findIndex(array: modelArray, mai: mai) {
                let model = modelArray[index]
                model.isMaiWeiMute = true
            }
        }
        
        // 遍历锁麦数组
        suoList.forEach { json in
            if let mai = json.string,
               let index = self.findIndex(array: modelArray, mai: mai) {
                let model = modelArray[index]
                model.isMaiWeiLock = true
            }
        }
        
        // 遍历自定义麦位名字数组
        maiweiNameList.forEach { json in
            if let mai = json["maino"].string,
               let name = json["name"].string,
               let index = self.findIndex(array: modelArray, mai: mai) {
                let model = modelArray[index]
                model.name = name
            }
        }
        
        defer {
            self.modelArray_vm.accept(modelArray)
        }
        
//        return modelArray
    }
    
    private func findIndex(array: [LQMaiWeiModel], mai: MaiWeiIndex?) -> Int? {
        let index = array.firstIndex(where: { $0.mai == mai })
        return index
    }
    
    private func findIndex(array: [LQMaiWeiModel], mai: String?) -> Int? {
        let index = array.firstIndex(where: { $0.mai?.rawValue == mai })
        return index
    }
    
    // 收到主持麦消息
    @objc func receiveHostMaiMessage(model: LQMaiWeiModel) {
        self.host_vm.accept(model)
    }
    
    /// 接收锁麦的消息推送
    @objc func receiveLockMaiMessage(text: String) {
        let json = JSON(parseJSON: text)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let index = self.findIndex(mai: mai) {
            let model = self.modelArray_vm.value[index]
            if type == "20" {
                model.isMaiWeiLock = true
            } else if type == "21" {
                model.isMaiWeiLock = false
            }
        }
    }
    
    /// 接收麦位禁言的消息推送
    @objc func receiveMuteMaiMessage(text: String) {
        let json = JSON(parseJSON: text)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let index = self.findIndex(mai: mai) {
            let model = self.modelArray_vm.value[index]
            if type == "24" {
                model.isMaiWeiMute = true
            } else if type == "25" {
                model.isMaiWeiMute = false
            }
        }
    }
    
    /// 接收修改麦位名字的消息推送
    @objc func receiveUpdateMaiNameMessage(text: String) {
        let json = JSON(parseJSON: text)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let index = self.findIndex(mai: mai) {
            let model = self.modelArray_vm.value[index]
            if type == "29" {
                let name = json["maiName"].string
                model.name = name
            }
        }
    }
    
    // 201:麦位魅力值推送，推送的是有人的所有麦位
    /*
    {
        "hotnum":"100",
        "hotsum":"3073128",
        "meiNum":"0",
        "dataList":[
            {
                "mai":"5",
                "meiNum":"100",
                "id":"e4a7c97b69d946c4b93ce44034e93716"
            },
            {
                "mai":"0",
                "meiNum":"0",
                "id":"fd56a01b47f949f5bcb1690d62f4aa8e"
            }
        ],
        "type":"201"
    }
    */
    /// 接收魅力值的消息推送
    @objc func receiveCharmListMessage(text: String) {
        let json = JSON(parseJSON: text)
        if let type = json["type"].string,
           let dataList = json["dataList"].array,
           dataList.count != 0 {
            
            dataList.forEach { charmJson in
                if let mai = charmJson["mai"].string {
                    // 如果是主持麦
                    if mai == MaiWeiIndex.host.rawValue {
                        self.host_vm.value.meiNum = charmJson["meiNum"].string
                        
                    } else if let index = self.findIndex(mai: mai), let charm = charmJson["meiNum"].string {
                        // 非主持麦
                        let model = self.modelArray_vm.value[index]
                        model.meiNum = charm
                    }
                }
            }
        }
    }
}
