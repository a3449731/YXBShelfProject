//
//  BannerViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/20.
//

import UIKit
import FSPagerView

class BannerViewController: UIViewController {
    // FSPagerView还有很多其他的效果，具体的直接看https://github.com/WenchaoD/FSPagerView
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: ScreenConst.width, height: 190))
        pagerView.transformer = FSPagerViewTransformer(type:.linear)
        pagerView.transformer?.minimumScale = 0.65
        pagerView.transformer?.minimumAlpha = 1
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3
        pagerView.removesInfiniteLoopForSingleItem = true
        // 这两行可以控制显示大小，可以关掉自己试试看
        let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
        pagerView.itemSize = pagerView.frame.size.applying(transform)
        pagerView.decelerationDistance = FSPagerView.automaticDistance
        // 垂直
//        pagerView.scrollDirection = .vertical
        // 水平
        pagerView.scrollDirection = .horizontal
        //注册cell
        pagerView.register(NewRoomCollectionViewCell.self, forCellWithReuseIdentifier:"NewRoomCollectionViewCell")
        return pagerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(200)
            make.height.equalTo(200)
        }
    }
}

extension BannerViewController : FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        // 点击事件
    }
}

extension BannerViewController : FSPagerViewDataSource {
    // 支持自定义cell，简单样式可以直接使用FSPagerViewCell
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "NewRoomCollectionViewCell", at: index) as! NewRoomCollectionViewCell
        cell.imageView?.image = UIImage(named: "wode_dress_preview")
        cell.textLabel?.text = "你好"
        return cell
    }
    
    /// 卡片的个数
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return  3
    }
}

