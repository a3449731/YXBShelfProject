//
//  LQPKRedBlueRateView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/6.
//

import UIKit

class LQPKRedBlueRateView: UIView {
    
    private let redView: GradientView = {
        let view = GradientView()
        view.makeGradient([UIColor(hex: 0xFFB1E4)!, UIColor(hex: 0xF721B0)!], direction: .fromTopToBottom)
        return view
    }()
    
    private let redLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "0", textColor: .titleColor_white, font: .titleFont_12)
        return label
    }()
 
    private let blueView: GradientView = {
        let view = GradientView()
        view.makeGradient([UIColor(hex: 0x9ADDFF)!, UIColor(hex: 0x24D2F8)!], direction: .fromTopToBottom)
        return view
    }()
    
    private let blueLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "0", textColor: .titleColor_white, font: .titleFont_12)
        return label
    }()
    
    private let fireImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "lq_pk_fire", placeholderImage: nil)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([redView, redLabel, blueView, blueLabel, fireImageView])
        
        redView.frame = CGRectMake(0, 0, ScreenConst.width / 2, 20.fitScale())
        blueView.frame = CGRectMake(ScreenConst.width / 2, 0, ScreenConst.width / 2, 20.fitScale())
        fireImageView.frame = CGRectMake(ScreenConst.width / 2 - 11.fitScale(), -16.fitScale(), 22.fitScale(), 36.fitScale())
        
        redLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        blueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateRate(red: Int, blue: Int) {
        if red + blue <= 0 {
            return
        }
        var rate = Double(red) / Double(red + blue)
        // 把rate的范围限定到0.1 ~ 0.9之间， 留一点余地
        rate = min(max(rate, 0.1), 0.9)
        let redWidth = ScreenConst.width * rate
        
        UIView.animate(withDuration: 1) {
            self.redView.width = redWidth
            self.fireImageView.x = redWidth - self.fireImageView.width / 2
            self.blueView.x = redWidth
            self.blueView.width = ScreenConst.width - redWidth
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    let firstView = LQPKRedBlueRateView()
    firstView.frame = CGRectMake(0, 150, ScreenConst.width, 20.fitScale())
    contentView.addSubview(firstView)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        firstView.updateRate(red: 1000, blue: 1)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
        firstView.updateRate(red: 10, blue: 1000)
    }
    
    
        
    return contentView
}
