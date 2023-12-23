//
//  LQPKSortUserView.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/12/6.
//

import UIKit

enum PKSortResultType {
    /// 贡献
    case contribution
    /// 人气
    case poplular
}

// pk结果用户头像
class LQPKSortResultUserView: LQPKSortUserView {
    // 积分
    lazy var scoreLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "", textColor: .titleColor_white, font: UIFont.systemFont(ofSize: 8), textAlignment: .center)
        return label
    }()
    
    // mvp
    lazy var mvpImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "lq_pk_mvp", placeholderImage: nil)
        return imageView
    }()
    
    var type: PKSortResultType?
    var sortResult: PKSortResult
    
    // 自定义初始化方法，要求PKSortResultType参数，还要PKSortResult参数
    init(sortResult: PKSortResult, type: PKSortResultType? = nil) {
        self.sortResult = sortResult
        self.type = type
        super.init(sortResult: sortResult)
        
        if let resultType = type {
            if resultType == .contribution {
                addSubview(scoreLabel)
                scoreLabel.backgroundColor = sortResult.borderColor
                scoreLabel.layer.cornerRadius = 5
                scoreLabel.layer.masksToBounds = true
                scoreLabel.snp.makeConstraints { make in
                    make.centerX.equalTo(headerImageView)
                    make.bottom.equalTo(headerImageView).offset(3)
                    make.width.equalTo(34)
                    make.height.equalTo(10)
                }
            }
            
            if resultType == .poplular,
               sortResult == .first {
                addSubview(mvpImageView)
                self.crownImageView.isHidden = true
                mvpImageView.snp.makeConstraints { make in
                    make.centerX.equalTo(headerImageView)
                    make.bottom.equalTo(headerImageView).offset(5)
                    make.width.equalTo(21)
                    make.height.equalTo(11)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 排序的view
class LQPKSortUserView: UIView {
    
    // 皇冠
    let crownImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(placeholderImage: nil)
        return imageView
    }()
    
    // 背景
    let bgBtn: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: nil)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    // 头像
    let headerImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(placeholderImage: nil, contentMode: .scaleAspectFill)
        return imageView
    }()
    
    init(sortResult: PKSortResult) {
        super.init(frame: .zero)
        
        addSubviews([bgBtn, headerImageView, crownImageView])
        
        if let crownImageName = sortResult.crownImageName {
            crownImageView.image = UIImage(named: crownImageName)
        }
        crownImageView.snp.makeConstraints { make in
            make.bottom.equalTo(bgBtn.snp.top).offset(8)
            make.left.equalTo(bgBtn).offset(-4)
            make.width.height.equalTo(16)
        }

        bgBtn.setImage(UIImage(named: sortResult.defaultImageName), for: .normal)
        bgBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        headerImageView.layer.cornerRadius = 12.5
        headerImageView.layer.masksToBounds = true
        headerImageView.layer.borderColor = sortResult.borderColor.cgColor
        headerImageView.layer.borderWidth = 1
        headerImageView.snp.makeConstraints { make in
            make.edges.equalTo(bgBtn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// pk结果排序
enum PKSortResult {
    case first
    case second
    case third
        
    var borderColor: UIColor {
        switch self {
        case .first: return UIColor(hex: 0xFFBE00)!
        case .second: return UIColor(hex: 0xA2A9FF)!
        case .third: return UIColor(hex: 0xFF897F)!
        }
    }
    
    // 默认图
    var defaultImageName: String {
        return "pk_sort_placeholder"
    }
    
    // 皇冠
    var crownImageName: String? {
        switch self {
            case .first: return "lq_pk_crown"
        default: return nil
        }
    }
}

#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    let firstView = LQPKSortUserView(sortResult: .first)
    firstView.frame = CGRectMake(0, 90, ScreenConst.width, 40.fitScale())
    firstView.headerImageView.image = UIImage(named: "CUYuYinFang_login_logo")
    contentView.addSubview(firstView)
    
    let secondView = LQPKSortUserView(sortResult: .second)
    secondView.frame = CGRectMake(0, 140, ScreenConst.width, 40.fitScale())
    contentView.addSubview(secondView)
    
    let sanView = LQPKSortResultUserView(sortResult: .first, type: .contribution)
    sanView.frame = CGRectMake(0, 200, ScreenConst.width, 40.fitScale())
    contentView.addSubview(sanView)
    
    let fourView = LQPKSortResultUserView(sortResult: .first, type: .poplular)
    fourView.frame = CGRectMake(0, 250, ScreenConst.width, 40.fitScale())
    contentView.addSubview(fourView)
    
    return contentView
}
