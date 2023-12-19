//
//  LQMicrophoneView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit
import SDWebImage

class LQMicrophoneUserView: UIView {
    
    weak var delegate: LQMicrophoneUserViewDelegate?
    
    // 麦波
    let rippleView: LQYinLiangView = {
        LQYinLiangView(frame: .zero)
    }()
    
    // 底图
    lazy var iconButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: UIImage(named: "CUYuYinFang_zhibojian_kongxian"))
        btn.addTarget(self, action: #selector(iconButtonAction), for: .touchUpInside)
        return btn
    }()
    
    // 头像 + 头像框
    lazy var headerView: HeaderStaticView = {
        let view = HeaderStaticView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerViewTapAction)))
        return view
    }()
    
    // 喇叭，闭麦状态下显示，开麦的时候隐藏
    let voiceImageView: UIImageView = {
        let view = MyUIFactory.commonImageView(name: "CUYuYinFang_roomDetail_bimai", placeholderImage: nil)
        view.isHidden = true
        return view
    }()
    
    // 提示文字位 -> 如：老板
    let tipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "老板", textColor: .titleColor_black, font: UIFont.systemFont(ofSize: 7), textAlignment: .center)
        label.backgroundColor = UIColor(hex: 0xF5D04B)
        label.isHidden = true
        return label
    }()
            
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([rippleView, iconButton, headerView, voiceImageView, tipLabel])
        
        rippleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(1.5)
        }
        
        iconButton.snp.makeConstraints { make in
            make.width.height.equalTo(50.fitScale())
            make.center.equalToSuperview()
        }
        
        headerView.headerImageView.layer.cornerRadius = 25.fitScale()
        headerView.headerImageView.layer.masksToBounds = true
        headerView.snp.makeConstraints { make in
            make.width.height.equalTo(50.fitScale())
            make.center.equalToSuperview()
        }
        
        voiceImageView.snp.makeConstraints { make in
            make.right.equalTo(headerView)
            make.bottom.equalTo(headerView)
            make.width.height.equalTo(12.fitScale())
        }
        
        tipLabel.layer.cornerRadius = 6.fitScale()
        tipLabel.layer.masksToBounds = true
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalTo(headerView)
            make.bottom.equalTo(headerView)
            make.width.equalTo(25.fitScale())
            make.height.equalTo(12.fitScale())
        }
        
    }
    
    @objc private func iconButtonAction() {
        self.delegate?.microphoneUserView?(view: self, didTapMaiWeiIcon: nil)
    }
    
    @objc private func headerViewTapAction() {
        self.delegate?.microphoneUserView?(view: self, didTapUserHeader: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




#Preview {
    let view = UIView()
    let contentView = LQMicrophoneUserView()
//    contentView.backgroundColor = .black
    contentView.frame = CGRectMake(200.fitScale(), 200, 60.fitScale(), 60.fitScale())
    
    if let url = Bundle.main.url(forResource: "micWave", withExtension: "webp") {
        contentView.rippleView.sd_setImage(with: url)
    }
        
    contentView.headerView.setImage(url:"https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1690792476235.jpg", headerFrameUrl: "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241627225.webp", placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
    view.addSubview(contentView)
    return view
}
