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

class LQMaiWeiViewModel {
    // 源数据
//    var modelArray: [LQMaiWeiModel] = []
    // 麦位设置了自定义名字的
//    var nameMaiWeiArray: [[String: String]]?
//    // 锁麦数据,两个单纯的["3", "5"],麦位下标数组
//    var lockMaiWeiArray: [String]?
//    // 闭麦数据,同上
//    var muteMaiWeiArray: [String]?
    
    // 房主数据
    var host_vm: BehaviorRelay<LQMaiWeiModel> = BehaviorRelay(value: LQMaiWeiModel())
    // 经过调整，能够直接去双向绑定的数据
    var modelArray_vm: BehaviorRelay<[LQMaiWeiModel]> = BehaviorRelay(value: [])
    
    // 创建空麦位，用于初始化，或者重置麦位的时候
    private func creatEmptyMaiWeiModel(index: Int) -> LQMaiWeiModel {
        let model = LQMaiWeiModel()
        model.mai = MaiWeiIndex(rawValue: "\(index)")
        model.maiNo = "\(index)"
        return model
    }
    
    // 初始化房主麦位数据
    func creatHostMaiWei() -> LQMaiWeiModel {
        let model = self.creatEmptyMaiWeiModel(index: 0)
        return model
    }
    
    // 初始化其他麦位数据
    func creatMaiWei(count: Int) -> [LQMaiWeiModel] {
        var array: [LQMaiWeiModel] = []
        for i in 1...count {
            let model = self.creatEmptyMaiWeiModel(index: i)
            array.append(model)
        }
        return array
    }
    
    // 通过接口获取麦位列表
    func requestMainWeiList(houseId: String, closure: @escaping () -> ()) {
        let network = NetworkManager<IMAPI>()
        network.sendRequest(.getMaiUserInfoList(houseId: houseId)) {[weak self] obj in
            guard let self = self else { return }
            
            if let json = obj as? [String: Any],
               let text = json.jsonString(prettify: true) {
                self.receiveAllMaiListMessage(text: text)
            }
            
            // 这里只给了麦上用户的信息，需要找到对应的麦位数据去修改
//            let array: [LQMaiWeiModel] = jsonToArray(jsonData: obj)
   
//            self.handle(array: array)
            // 为外界预留一个回调，不一定用得上
            closure()
        } failure: { error in
            // 为外界预留一个回调，不一定用得上
            closure()
        }
    }    

    // 通过麦位找下标
    func findIndex(mai: MaiWeiIndex?) -> Int? {
        let index = self.modelArray_vm.value.firstIndex(where: { $0.mai == mai })
        return index
    }
    func findIndex(mai: String?) -> Int? {
        let index = self.modelArray_vm.value.firstIndex(where: { $0.mai?.rawValue == mai })
        return index
    }
    
    // 通过uid找下标，可能为空
    func findIndex(uid: String?) -> Int? {
        let index = self.modelArray_vm.value.firstIndex(where: { $0.id == uid })
        return index
    }
    
    
}
