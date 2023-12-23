//
//  BaseViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/18.
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
