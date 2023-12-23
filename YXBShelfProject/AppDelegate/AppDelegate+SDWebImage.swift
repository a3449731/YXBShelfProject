//
//  AppDelegate+SDWebImage.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/24.
//

import Foundation
import SDWebImage

extension AppDelegate {
    func setupSDWebImage() {
        SDImageCodersManager.shared.addCoder(SDImageAWebPCoder.shared)
    }
}

