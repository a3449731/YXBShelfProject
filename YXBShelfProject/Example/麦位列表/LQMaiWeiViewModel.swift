//
//  LQMaiWeiViewModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class LQMaiWeiViewModel {
    // 源数据
//    var modelArray: [LQMaiWeiModel] = []
    // 房主数据
    var host_vm: BehaviorRelay<LQMaiWeiModel> = BehaviorRelay(value: LQMaiWeiModel())
    // 经过调整，能够直接去双向绑定的数据
    var modelArray_vm: BehaviorRelay<[LQMaiWeiModel]> = BehaviorRelay(value: [])
    
    // 创建空麦位，用于初始化，或者重置麦位的时候
    func creatEmptyMaiWeiModel(index: Int) -> LQMaiWeiModel {
        let model = LQMaiWeiModel()
        model.mai = "\(index)"
        model.maiNo = "\(index)"
        return model
    }
    
    // 初始化房主麦位数据
    func creatHostMaiWei() {
        let model = self.creatEmptyMaiWeiModel(index: 0)
        host_vm.accept(model)
    }
    
    // 初始化其他麦位数据
    func creatMaiWei(count: Int) {
        var array: [LQMaiWeiModel] = []
        for i in 1...count {
            let model = self.creatEmptyMaiWeiModel(index: i)
            array.append(model)
        }
        modelArray_vm.accept(array)
    }
    
    // 通过接口获取麦位列表
    func requestMainWeiList(houseId: String, closure: @escaping () -> ()) {
        let network = NetworkManager<IMAPI>()
        network.sendRequest(.getMaiUserInfoList(houseId: houseId)) {[weak self] obj in
            guard let self = self else { return }
            // 这里只给了麦上用户的信息，需要找到对应的麦位数据去修改
            let array: [LQMaiWeiModel] = jsonToArray(jsonData: obj)
   
            self.handle(array: array)
            // 为外界预留一个回调，不一定用得上
            closure()
        } failure: { error in
            // 为外界预留一个回调，不一定用得上
            closure()
        }
    }
    
    // 找到有人的麦位进行替换
    private func handle(array: [LQMaiWeiModel]) {
        // 房主麦位
        var hostModel = self.host_vm.value
        // 其他麦位
        var modelArray = self.modelArray_vm.value
        
        array.forEach { model in
            // 通过麦位号进行数据替换
            if let index = modelArray.firstIndex(where: { $0.mai == model.mai }) {
                modelArray[index] = model
            }
            
            // 房主
            if model.mai == "0" {
                hostModel = model
                self.host_vm.accept(hostModel)
            }
        }
        self.modelArray_vm.accept(modelArray)
    }

}
