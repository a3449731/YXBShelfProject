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
            self.add(dic: [:])
        }
    }
    
    @objc func add(dic: [String: Any]) {
//        let model = LQAnimationModel.deserialize(from: dic)
        var model: LQAnimationModel?  = LQAnimationModel()
        model?.floatType = .gift
                     
        if let model = model,
           let floatType = model.floatType {
            switch floatType {
            case .gift:
                floatAnimationQueue.playView = giftAnimationView
            case .nobble:
                floatAnimationQueue.playView = nobbleAnimationView
            case .redPacket:
                break
            case .bigGift:
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
    PiaoPingViewController()
}
