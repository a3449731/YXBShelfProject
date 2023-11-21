//
//  ExampleViewController+.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit

extension ExampleViewController: UINavigationControllerDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.delegate = nil
    }
    
    // UINavigationControllerDelegate,这里是配置转场动画的
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if toVC is MaskViewController && operation == .push {
            return LQCircleMaskAnimation()
        } else {
            return nil
        }
    }
}
