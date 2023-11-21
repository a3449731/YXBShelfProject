//
//  YXBPhotoBrowswer.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit
import JXPhotoBrowser
import SDWebImage

/// JXPhotoBrowser蜂巢开源的图片浏览控件，更多使用参考链接 https://github.com/JiongXing/PhotoBrowser
class YXBPhotoBrowswer {
    static func show(urlArray: [String], currentIndex: Int) {
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            urlArray.count
        }
        browser.reloadCellAtIndex = { context in
            let url = URL(string: urlArray[context.index])
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            browserCell?.index = context.index
            // 用 SDWebImage 加载
            browserCell?.imageView.sd_setImage(with: url, placeholderImage: nil)
        }
        
        // UIPageIndicator样式的页码指示器
        browser.pageIndicator = JXPhotoBrowserDefaultPageIndicator()
        // 初始化在第几个
        browser.pageIndex = currentIndex
        browser.show()
    }
}
