//
//  PiaoPingViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/22.
//

import UIKit

class PiaoPingViewController: UIViewController {
    
    // 送礼飘屏
    @objc let giftAnimationView = FloatingScreenView()
    // 大礼物飘屏
    @objc let bigGiftAnimationView = FSBigGiftView()
    // 贵族升级
    @objc let nobbleAnimationView = FSNobbleView()
    
    // 飘屏的管理队列
    lazy var floatAnimationQueue = LQAnimationQueue<FloatingBaseView>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftAnimationView.frame = CGRectMake(16.fitScale(), ScreenConst.statusBarHeight + 41.fitScale(), ScreenConst.width - 32.fitScale(), 33.fitScale())
        
        bigGiftAnimationView.frame = CGRectMake((ScreenConst.width - 345)/2, ScreenConst.statusBarHeight + 41.fitScale(), 345, 39)
        
        nobbleAnimationView.frame = CGRectMake((ScreenConst.width - 345)/2, ScreenConst.statusBarHeight + 41.fitScale(), 345, 39)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            debugPrint("添加示例")
            // MARK: -这个floatType在PreView中没能成功转换成枚举，不知是为什么。在真机中可以
            let dic: [String: Any] = ["nickname":"张八", "floatType": 4]
            self.add(dic: dic)
            
        }
        
    }
    
    @objc func add(dic: [String: Any]) {
        let model = LQAnimationModel.deserialize(from: dic)
        debugPrint("转化的模型", model, "如果是你是在PreView中执行的，请忽略，他转换不成功枚举。")
//        var model: LQAnimationModel?  = LQAnimationModel()
//        model?.floatType = .gift
                     
        if let model = model,
           let floatType = model.floatType {
            switch floatType {
            case .gift:
                floatAnimationQueue.playView = giftAnimationView
            case .nobble:
                floatAnimationQueue.playView = nobbleAnimationView
            case .redPacket:
                break
            case .bigGift, .active:
                floatAnimationQueue.playView = bigGiftAnimationView
            }
        }
        
        if let model = model {
            floatAnimationQueue.addAnimation(model)
        }
        floatAnimationQueue.playAnimations()
    }
    
}

#Preview {
    let vc = PiaoPingViewController()
    
//   let tempstring = """
//    {"gift":{"giftImg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1701507467381.png","giftName":"绮梦星光","num":"1"},"floatType":5,"activityUrl":"https://lanyu.whlqhy.online/jnh/","headImg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1700894442151.webp","nickname":"张八","activityName":"时光扭蛋机","jueName":"帝王","id":"aab8b0b8ac674f98be779144cbccc169","isex":"1","type":"409","scopeFloat":5}
//"""
//    
//    
//    if let dic = try? tempstring.data(using: .utf8)?.jsonObject() as? [String: Any] {
//        debugPrint("我要准备添加",dic)
//        vc.add(dic: dic)
//    }
    
    return vc
}
