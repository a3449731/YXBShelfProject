//
//  NewRoomCollectionViewCell.swift
//  voice
//
//  Created by mac on 2023/3/16.
//

import UIKit
import FSPagerView

// 可以自定义样式
class NewRoomCollectionViewCell: FSPagerViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func initSubViews() {
        // 添加到self上
//        self.addSubview(xxx)
    }
}
