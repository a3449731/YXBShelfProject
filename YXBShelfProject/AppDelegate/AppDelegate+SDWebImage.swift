//
//  AppDelegate+SDWebImage.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import Foundation
import SDWebImage

extension AppDelegate {
    func setupSDWebImage() {
        SDImageCodersManager.shared.addCoder(SDImageAWebPCoder.shared)
    }
}

