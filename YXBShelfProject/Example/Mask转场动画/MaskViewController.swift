//
//  MaskViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit

class MaskViewController: YXBBaseViewController {
        
    private var btn: UIButton!
    // 浮窗管理
    private var touchViewManager = LJKAudioTouchViewManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.touchViewManager.hideAudioCallAssistiveTouchView()
        self.navigationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.touchViewManager.showAudioCallAssistiveTouchView()
        self.navigationController?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        
        self.view.backgroundColor = .red
        
        btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 150, y: 150, width: 150, height: 50)
        btn.setTitle("最小化", for: .normal)
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(smallButtonAction), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func smallButtonAction() {
        // Perform action for small button
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: LJKAudioCallAssistiveTouchViewDelegate
extension MaskViewController: UINavigationControllerDelegate {
    
    // UINavigationControllerDelegate,这里是配置转场动画的
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is MaskViewController && operation == .pop {
            return LQCircleMaskAnimation()
        } else {
            return nil
        }
    }
}
