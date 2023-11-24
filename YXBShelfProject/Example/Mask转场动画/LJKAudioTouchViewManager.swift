//
//  LJKAudioTouchViewManager.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit

class LJKAudioTouchViewManager: NSObject {
    static let shared = LJKAudioTouchViewManager()
    
    // 浮窗
    var touchView: LJKAudioCallAssistiveTouchView!
    
    private override init(){
        super.init()
        self.touchView = LJKAudioCallAssistiveTouchView()
        self.touchView.delegate = self
    }
    
    func hideAudioCallAssistiveTouchView() {
        self.touchView.removeFromSuperview()
    }
    
    func showAudioCallAssistiveTouchView() {
        UIApplication.shared.getCurrentUIController()?.view.addSubview(self.touchView)
        self.touchView.nameLabel.text = "房间名"
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
        self.touchView.delegate = nil
        self.touchView = nil
    }
}

extension LJKAudioTouchViewManager: LJKAudioCallAssistiveTouchViewDelegate {
    // 点击其他地方
    func assistiveTouchViewClicked() {
        let vc = MaskViewController()
//        self.touchView.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        if let nav = UIApplication.shared.getCurrentUIController() as? UINavigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            UIApplication.shared.getCurrentUIController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 点击了关闭按钮
    func closeClicked() {
        self.hideAudioCallAssistiveTouchView()
    }
}
