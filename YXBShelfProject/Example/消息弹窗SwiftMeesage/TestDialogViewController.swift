//
//  TestDialogViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/12/23.
//

import UIKit

class TestDialogViewController: UIViewController {
    
    let btn = MyUIFactory.commonButton(title: "你好", titleColor: nil, titleFont: nil, image: nil)
    
    var didTaoHelloClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        btn.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc func tapAction() {
        debugPrint("怎么回事哦")
        self.didTaoHelloClosure?()
    }
    
//    override var preferredContentSize: CGSize {
//        get {
//            return CGSize(width: 300, height: 200) // 设置自定义视图控制器的首选尺寸
//        }
//        set {
//            super.preferredContentSize = newValue
//        }
//    }

}
