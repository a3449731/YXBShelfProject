//
//  LQMaiWeiViewModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class LQMaiWeiViewModel: NSObject {
    // 源数据
//    var modelArray: [LQMaiWeiModel] = []
    
    // 房主数据
    var host_vm: BehaviorRelay<LQMaiWeiModel> = BehaviorRelay(value: LQMaiWeiModel())
    // 经过调整，能够直接去双向绑定的数据
    var modelArray_vm: BehaviorRelay<[LQMaiWeiModel]> = BehaviorRelay(value: [])
    
    // 创建空麦位，用于初始化，或者重置麦位的时候
    private func creatEmptyMaiWeiModel(index: Int, roomType: LQRoomType) -> LQMaiWeiModel {
        let model = LQMaiWeiModel()
        model.mai = MaiWeiIndex(rawValue: "\(index)")
        model.maiNo = "\(index)"
        model.roomType = roomType
        return model
    }
    
    // 初始化房主麦位数据
    func creatHostMaiWei(roomType: LQRoomType) -> LQMaiWeiModel {
        let model = self.creatEmptyMaiWeiModel(index: 0, roomType: roomType)
        return model
    }
    
    // 初始化其他麦位数据
    func creatMaiWei(count: Int, roomType: LQRoomType) -> [LQMaiWeiModel] {
        var array: [LQMaiWeiModel] = []
        for i in 1...count {
            let model = self.creatEmptyMaiWeiModel(index: i, roomType: roomType)
            array.append(model)
        }
        return array
    }
    
    // 暴露给oc用的才套了一层
    @objc func requestMainWeiList(houseId: String, roomType: String, success: @escaping () -> (), fail: @escaping () -> ()) {
        guard let type = LQRoomType(rawValue: roomType) else {
            debugPrint("xxxxxxxxx 房间类型不合法 xxxxxxxxxxx")
            return
        }
        requestMainWeiList(houseId: houseId, roomType: type, success: success, fail: fail)
    }
    
    // 通过接口获取麦位列表
    func requestMainWeiList(houseId: String, roomType: LQRoomType, success: @escaping () -> (), fail: @escaping () -> ()) {
        let network = NetworkManager<IMAPI>()
        network.sendRequest(.getMaiUserInfoList(houseId: houseId)) {[weak self] obj in
            guard let self = self else { return }
            
            if let json = obj as? [String: Any] {
//                let text = json.jsonString(prettify: true)
                self.receiveAllMaiListMessage(dic: json, roomType: roomType)
            }
            
            // 这里只给了麦上用户的信息，需要找到对应的麦位数据去修改
//            let array: [LQMaiWeiModel] = jsonToArray(jsonData: obj)
   
//            self.handle(array: array)
            // 为外界预留一个回调，不一定用得上
            success()
        } failure: { error in
            // 为外界预留一个回调，不一定用得上
            fail()
        }
    }
}
