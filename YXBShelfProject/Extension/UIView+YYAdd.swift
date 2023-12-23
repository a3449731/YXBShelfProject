//
//  UIView+YYAdd.swift
//  CUYuYinFang
//
//  Created by yangxiaobin on 2023/11/11.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import UIKit

extension UIView {
    func yxb_snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
}
