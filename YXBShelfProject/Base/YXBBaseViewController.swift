//
//  BaseViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/18.
//

import UIKit

class YXBBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}
