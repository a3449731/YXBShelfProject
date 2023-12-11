//
//  LQPKRankView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/6.
//

import UIKit

class LQPKRankView: UIView {
    
    // 头像
    private let bgImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name:"lq_pk_three", placeholderImage: nil)
        return imageView
    }()
    
    // 红方提示
    lazy var redTipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "本场贡献 前三", textColor: UIColor(hex: 0xFFFFFF, transparency: 0.8), font: UIFont.systemFont(ofSize: 9), lines: 0)
        return label
    }()
    
    // 红方前三容器
    lazy var redRankStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // 蓝方提示
    lazy var blueTipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "本场贡献 前三", textColor: UIColor(hex: 0xFFFFFF, transparency: 0.8), font: UIFont.systemFont(ofSize: 9), lines: 0)
        return label
    }()
    
    // 蓝方前三容器
    lazy var blueRankStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([bgImageView, redTipLabel, redRankStack, blueTipLabel, blueRankStack])
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        redTipLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        blueTipLabel.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        let redFirstView = LQPKSortUserView(sortResult: .first)
        let redScondView = LQPKSortUserView(sortResult: .second)
        let redThirdView = LQPKSortUserView(sortResult: .third)
        redRankStack.addArrangedSubviews([redFirstView, redScondView, redThirdView])
        
        let blueFirstView = LQPKSortUserView(sortResult: .first)
        let blueScondView = LQPKSortUserView(sortResult: .second)
        let blueThirdView = LQPKSortUserView(sortResult: .third)
        blueRankStack.addArrangedSubviews([blueFirstView, blueScondView, blueThirdView])
                
        redFirstView.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(40)
        }
                
        redScondView.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(40)
        }
        
        redThirdView.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(40)
        }
                
        redRankStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(60)
        }
        
        blueFirstView.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(40)
        }
                
        blueScondView.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(40)
        }
        
        blueThirdView.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(40)
        }
        
        blueRankStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    let firstView = LQPKRankView()
    firstView.frame = CGRectMake(0, 150, ScreenConst.width, 46.fitScale())
    contentView.addSubview(firstView)
    
    return contentView
}
