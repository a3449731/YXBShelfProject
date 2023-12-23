//
//  LoadingGiftViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/21.
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
