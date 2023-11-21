//
//  LoadingGiftViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit

class LoadingGiftViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingGifView.showGifToView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            LoadingGifView.hideGifHUDForView()
        }
    }
    
}
