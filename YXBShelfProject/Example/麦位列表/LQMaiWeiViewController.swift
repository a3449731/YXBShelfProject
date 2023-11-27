//
//  LQMaiWeiViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit

class LQMaiWeiViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maiView = LQAllMailWeiView()
        self.view.addSubview(maiView)
        maiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}

