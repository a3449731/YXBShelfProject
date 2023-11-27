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
    
    /// 收到全麦List的消息推送, 重置全麦数据重新配置
    //    200, 204,收到当前麦位状态推送，另外接口请求的数据结构也与这一模一样。
    @objc func receiveAllMaiListMessage(text: String) -> [LQMaiWeiModel]? {
        let json = JSON(parseJSON: text)
        let biList = json["biList"].arrayValue
        let suoList = json["suoList"].arrayValue
        let maiweiNameList = json["maiweiNameList"].arrayValue
                
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
        
        return modelArray
    }
    
    private func findIndex(array: [LQMaiWeiModel], mai: String?) -> Int? {
        let index = array.firstIndex(where: { $0.mai == mai })
        return index
    }
    
    /// 接收锁麦的消息推送
    @objc func receiveLockMaiMessage(text: String) {
        let json = JSON(text)
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
        let json = JSON(text)
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
        let json = JSON(text)
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
}
