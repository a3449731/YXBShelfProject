//
//  LQMaiWeiView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit

class LQMaiWeiView: UIView {
    
    weak var delegate: LQMaiWeiViewDelegate?
    
    // 头像 + 头像框 + 麦波
    lazy var userView: LQMicrophoneUserView = {
        let view = LQMicrophoneUserView()
        view.delegate = self
        return view
    }()
    
    // 容器
    lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    // 序号
    let sortLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: nil, textColor: .titleColor_white, font: UIFont.systemFont(ofSize: 8), textAlignment: .center)
        label.backgroundColor = UIColor(hex: 0xFF4E73)
        return label
    }()
    
    // 身份，主持
    let identityImageView: UIImageView = {
        let view = MyUIFactory.commonImageView(name: nil, placeholderImage: nil)
        return view
    }()
    
    // 昵称 / 标题
    let titleLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: nil, textColor: .titleColor_white, font: UIFont.systemFont(ofSize: 9))
        return label
    }()
    
    // 魅力值
    lazy var charmButton: YXBButton = {
        let btn = MyUIFactory.commonImageTextButton(title: nil, titleColor: .titleColor_white, titleFont: UIFont.systemFont(ofSize: 8), image: UIImage(named: "CUYuYinFang_zhibojian_xin"), bgColor: UIColor(hex: 0x737373, transparency: 0.2), postion: .left, space: 2)
        btn.addTarget(self, action: #selector(charmButtonAction), for: .touchUpInside)
        return btn
    }()
            
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([userView, hStack, charmButton])
        hStack.addArrangedSubviews([identityImageView, sortLabel, titleLabel])
        
        userView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60.fitScale())
        }
        
        hStack.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
        }
        
        identityImageView.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(10)
        }
                
        sortLabel.layer.cornerRadius = 5
        sortLabel.layer.masksToBounds = true
        sortLabel.snp.makeConstraints { make in
            make.width.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(13)
        }
        
        charmButton.layer.cornerRadius = 5
        charmButton.layer.masksToBounds = true
        charmButton.snp.makeConstraints { make in
            make.top.equalTo(hStack.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(12)
        }
    }
    
    @objc private func charmButtonAction() {
        self.delegate?.maiWeiView?(view: self, didTapCharmView: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LQMicrophoneUserViewDelegate 代理
extension LQMaiWeiView: LQMicrophoneUserViewDelegate {
    // 点击了麦位的icon。
    func microphoneUserView(view: LQMicrophoneUserView, didTapUserHeader: LQMaiWeiModel?) {
        self.delegate?.maiWeiView?(view: self, didTapUserHeader: nil)
    }
    
    // 麦上有用户，点击的是userheader。
    func microphoneUserView(view: LQMicrophoneUserView, didTapMaiWeiIcon: LQMaiWeiModel?) {
        self.delegate?.maiWeiView?(view: self, didTapMaiWeiIcon: nil)
    }
}

#Preview {
    let view = UIView()
    let contentView = LQMaiWeiView()
    contentView.backgroundColor = .cyan
    contentView.frame = CGRectMake(200.fitScale(), 200, 60.fitScale(), 100.fitScale())
    contentView.userView.headerView.setImage(url: "https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1690792476235.jpg", headerFrameUrl: "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241627225.webp", placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
    contentView.hStack.backgroundColor = .black
    contentView.titleLabel.text = "Ss.草电风."
    contentView.sortLabel.text = "4"
    contentView.identityImageView.image = UIImage(named: "CUYuYinFang_fanzhuHead")
    contentView.charmButton.setTitle("1000w", for: .normal)
    view.addSubview(contentView)
    return view
}
