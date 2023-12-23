//
//  LQPKRedBlueResultView.swift
//  CUYuYinFang
//
//  Created by yangxiaobin on 2023/12/11.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import UIKit

class LQPKRedBlueResultView: UIView {
    
    enum PKRedBlueResult: String {
        /// 平局
        case equal = "0"
        /// 红方赢
        case redWin = "1"
        /// 蓝方赢
        case blueWin = "2"
        
        // 红方图片
        var redImageName: String {
            switch self {
            case .equal: return "lq_pk_result_he"
            case .redWin: return "lq_pk_result_win"
            case .blueWin: return "lq_pk_result_fail"
            }
        }
        
        // 蓝方图片
        var blueImageName: String {
            switch self {
            case .equal: return "lq_pk_result_he"
            case .redWin: return "lq_pk_result_fail"
            case .blueWin: return "lq_pk_result_win"
            }
        }
    }
    
    
    lazy var redImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "lq_pk_result_win", placeholderImage: nil)
        return imageView
    }()
        
    lazy var blueImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "lq_pk_result_fail", placeholderImage: nil)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        
        addSubviews([redImageView, blueImageView])
        
        redImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
            make.width.equalTo(112.fitScale())
            make.height.equalTo(60.fitScale())
        }
        
        blueImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalToSuperview()
            make.width.equalTo(112.fitScale())
            make.height.equalTo(60.fitScale())
        }
    }
    
    func update(result: PKRedBlueResult) {
        self.isHidden = false
        redImageView.image = UIImage(named: result.redImageName)
        blueImageView.image = UIImage(named: result.blueImageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    let firstView = LQPKRedBlueResultView()
    firstView.frame = CGRectMake(0, 150, ScreenConst.width, 60.fitScale())
    contentView.addSubview(firstView)

    firstView.update(result: .equal)

    return contentView
}
