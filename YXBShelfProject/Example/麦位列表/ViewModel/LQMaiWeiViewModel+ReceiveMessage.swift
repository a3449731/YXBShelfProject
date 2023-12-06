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
    @objc func receiveAllMaiListMessage(dic: [String: Any], roomType: String) {
        guard let type = LQRoomType(rawValue: roomType) else {
            debugPrint("xxxxxxxxx 房间类型不合法 xxxxxxxxxxx")
            return
        }
        receiveAllMaiListMessage(dic: dic, roomType: type)
    }
    func receiveAllMaiListMessage(dic: [String: Any], roomType: LQRoomType) {
        let json = JSON(dic)
        let biList = json["biList"].arrayValue
        let suoList = json["suoList"].arrayValue
        let maiweiNameList = json["maiweiNameList"].arrayValue
        
        // 数据全部重置为新的数据
        var modelArray: [LQMaiWeiModel] = []
        switch roomType {
        case .merchant_9, .personal:
            self.host_vm.accept(self.creatHostMaiWei(roomType: roomType))
            modelArray = self.creatMaiWei(count: 8, roomType: roomType)
        case .merchant_5:
            modelArray = self.creatMaiWei(count: 4, roomType: roomType)
        }
        
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
    
    // 通过uid找麦位模型,这时候要连主持麦一起找
    @objc func findModel(uid: String) -> LQMaiWeiModel? {
        let hostModel = self.host_vm.value
        if hostModel.id == uid {
            return hostModel
        }
        
        let model = self.modelArray_vm.value.first(where: { $0.id == uid })
        return model
    }
    
    // 通过麦位下标找麦位模型, 暴露给OC用的。
    @objc func findModel(mai: String) -> LQMaiWeiModel? {
        guard let index = MaiWeiIndex(rawValue: mai) else {
            debugPrint("麦位下标不合法")
            return nil
        }
        return findModel(mai: index)
    }
    
    // 通过麦位下标找麦位模型
    func findModel(mai: MaiWeiIndex) -> LQMaiWeiModel? {
        let hostModel = self.host_vm.value
        if hostModel.mai == mai {
            return hostModel
        }
        
        let model = self.modelArray_vm.value.first(where: { $0.mai == mai })
        return model
    }
    
    // 查询所有麦位
    @objc func findAllMaiWei() -> [LQMaiWeiModel] {
        var arrray: [LQMaiWeiModel] = [self.host_vm.value]
        arrray.append(contentsOf:self.modelArray_vm.value)
        return arrray
    }
    
    // 查询所有有人在的麦位
    @objc func findAllUserfulMaiWei() -> [LQMaiWeiModel] {
        var arrray: [LQMaiWeiModel] = []
        if let uid = self.host_vm.value.id,
           uid.isEmpty == false {
            arrray.append(self.host_vm.value)
        }
        
        for model in self.modelArray_vm.value {
            if let uid = model.id,
               uid.isEmpty == false {
                arrray.append(model)
            }
        }
        return arrray
    }
    
    // MARK: - 收到某些im消息
    // 收到主持麦消息
    @objc func receiveHostMaiMessage(model: LQMaiWeiModel) {
        self.host_vm.accept(model)
    }
    
    // 收到表情消息
    @objc func receiveEmjiomMessage(dic: [String: Any]) {
        let json = JSON(dic)
        if let type = json["type"].string,
           let uid = json["uid"].string,
           let model = self.findModel(uid: uid),
           let url = json["url"].string {
            if type == "207" {
                model.emotionUrl = url
            }
        }
    }
    
    /*
     // 7：有人闭麦。 8: 有人开麦。
    Rtm频道消息:{
      "mai" : "2",
      "uid" : "fd56a01b47f949f5bcb1690d62f4aa8e",
      "type" : "8",
      "uname" : "哈欠不断扩大用户收入囊中"
    }
    */
    // 收到有人开闭麦的消息
    @objc func receiveOpenCloseMaiMessage(dic: [String: Any]) {
        let json = JSON(dic)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let model = self.findModel(mai: mai) {
            if type == "7" {
                model.isb = true
            } else if type == "8" {
                model.isb = false
            }
        }
    }
    

    
    /*
     // 20: 麦位被锁,关闭。， 21: 麦位解锁，打开
     Rtm频道消息:{
     "type" : "20",
     "mai" : "2"
     }
     */
    /// 接收锁麦的消息推送
    @objc func receiveLockMaiMessage(dic: [String: Any]) {
        let json = JSON(dic)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let model = self.findModel(mai: mai) {
            if type == "20" {
                model.isMaiWeiLock = true
            } else if type == "21" {
                model.isMaiWeiLock = false
            }
        }
    }
    
    
    /*
     // 24: 麦位禁言， 25: 麦位不禁言
     Rtm频道消息:{
     "type" : "24",
     "mai" : "2"
     }
     */
    /// 接收麦位禁言的消息推送
    @objc func receiveMuteMaiMessage(dic: [String: Any]) {
        let json = JSON(dic)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let model = self.findModel(mai: mai) {
            if type == "24" {
                model.isMaiWeiMute = true
            } else if type == "25" {
                model.isMaiWeiMute = false
            }
        }
    }
    
    /*
     // 29: 修改了麦位名字
     Rtm频道消息:{
     "type" : "29",
     "mai" : "2",
     "maiName" : "在下"
     }
     */
    /// 接收修改麦位名字的消息推送
    @objc func receiveUpdateMaiNameMessage(dic: [String: Any]) {
        let json = JSON(dic)
        if let type = json["type"].string,
           let mai = json["mai"].string,
           let model = self.findModel(mai: mai) {
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
        "meiNum":"0", // 这个值就是5人房 房主的魅力值
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
    @objc func receiveCharmListMessage(dic: [String: Any], roomType: String) {
        guard let type = LQRoomType(rawValue: roomType) else {
            debugPrint("xxxxxxxxx 房间类型不合法 xxxxxxxxxxx")
            return
        }
        receiveCharmListMessage(dic: dic, roomType: type)
    }
    func receiveCharmListMessage(dic: [String: Any], roomType: LQRoomType) {
        let json = JSON(dic)
        if let type = json["type"].string,
           let dataList = json["dataList"].array {
            
            dataList.forEach { charmJson in
                if let mai = charmJson["mai"].string {
                    // 如果是主持麦
                    if mai == MaiWeiIndex.host.rawValue {
                        self.host_vm.value.meiNum = charmJson["meiNum"].string
                    } else if let model = self.findModel(mai: mai), let charm = charmJson["meiNum"].string {
                        // 非主持麦
                        model.meiNum = charm
                    }
                }
            }
            
            // 5人房 房主的魅力值是外层的值
            if roomType == .merchant_5 {
                self.host_vm.value.meiNum = json["meiNum"].string
            }
        }
    }
}
