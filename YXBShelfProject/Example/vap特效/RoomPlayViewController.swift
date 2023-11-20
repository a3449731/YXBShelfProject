//
//  RoomPlayViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/20.
//

import UIKit

/// 播放vap动效的示例， 注意不要在模拟器上跑，请用真机调试
class RoomPlayViewController: YXBBaseViewController {
    
    var giftAnimationManager: RoomPlayJoinEffectManager!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 播放动画
            self.giftAnimationManager.playAnimations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIView(frame: CGRectMake(0, 200, ScreenConst.width, 400))
        view.addSubview(contentView)
        
        giftAnimationManager = RoomPlayJoinEffectManager(superView: contentView)
        giftAnimationManager.delegate = self
        let array = [
            ["passAction" : "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1698288781473.mp4",
             "nickname" : "",
             "headImg" : ""],
            ["passAction" : "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1698288863069.mp4",
             "nickname" : "",
             "headImg" : ""
            ]
        ]
        self.giftAnimationManager.addAnimations(array)
    }
}

extension RoomPlayViewController: RoomPlayJoinEffectManagerDelegate {
    func playVap(_ view: PlayVapView, didStart container: UIView, url urlString: String) {
        
    }
    
    func playVap(_ view: PlayVapView, didStop container: UIView, url urlString: String) {
        self.giftAnimationManager.next()
    }
    
    func playVap(_ view: PlayVapView, didFail error: Error, url urlString: String) {
        
    }
}
