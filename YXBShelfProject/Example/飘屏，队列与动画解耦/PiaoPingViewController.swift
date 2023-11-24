//
//  PiaoPingViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/22.
//

import UIKit

class PiaoPingViewController: UIViewController {
    
    // 飘屏的管理队列
    let floatAnimationView = FloatingScreenView()
    lazy var floatAnimationQueue = {
        LQAnimationQueue(playView: floatAnimationView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(floatAnimationView)
        floatAnimationView.snp.makeConstraints { make in
            make.top.equalTo(200);
            make.left.equalToSuperview().offset(16.fitScale())
            make.right.equalToSuperview().offset(-16.fitScale())
            make.height.equalTo(33.fitScale())
        }
        
        do {
            var model = LQAnimationModel()
            floatAnimationQueue.addAnimation(model)
        }
        
        do {
            var model = LQAnimationModel()
            floatAnimationQueue.addAnimation(model)
        }
        
         
        floatAnimationQueue.playAnimations()
    }
    
}

#Preview {
    PiaoPingViewController()    
    
}
