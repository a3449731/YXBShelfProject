//
//  LoadingGifView.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/21.
//

import UIKit
import SDWebImage
import MBProgressHUD
import SnapKit

class LoadingGifView {
    static func showGifToView(_ view: UIView? = nil) {
        var targetView = view
        if targetView == nil {
            targetView = UIApplication.shared.getKeyWindow()
        }
        showGifToView(targetView, gifName: "refeshIcon")
    }
    
    static func showGifToView(_ view: UIView?, gifName: String) {
        var targetView = view
        if targetView == nil {
            targetView = UIApplication.shared.delegate?.window!
        }
        guard let view = targetView else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif") else {
            return
        }
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.sd_setImage(with: url)
        let myView = UIView()
        myView.backgroundColor = .clear
        myView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(myView)
            make.width.height.equalTo(50)
        }
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = .clear
        hud.customView = myView
    }
    
    static func hideGifHUDForView(_ view: UIView? = nil) {
        var targetView = view
        if targetView == nil {
            targetView = UIApplication.shared.getKeyWindow()
        }
        guard let view = targetView else {
            return
        }
        MBProgressHUD.hide(for: view, animated: true)
    }
}
