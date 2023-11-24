//
//  FSBigGiftView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/23.
//

import UIKit

/// 大礼物飘屏的view
class FSBigGiftView: UIView, LQPlayableAnimation, LQFloatAnimation {
    weak var delegate: LQAnimationDelegate?
    
    private let floatingScreenAnimationKey = "FloatingScreenAnimation"
        
    // 背景图
    let bgImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "float_big_type_1", placeholderImage: nil)
        return imageView
    }()
    
    let tipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "恭喜", textColor: .titleColor_white, font: UIFont.systemFont(ofSize: 11))
        return label
    }()
    
    // 送的头像
    let headerFromImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 送的昵称
    lazy var nameFromButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: "用户昵称昵称啊啊发", titleColor: .titleColor_yellow, titleFont: .titleFont_11, image: nil)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
        btn.addTarget(self, action: #selector(fromNameTapAction), for: .touchUpInside)
        return btn
    }()

    // 收到的昵称
    lazy var nameToBtn: UIButton = {
        let btn = MyUIFactory.commonButton(title: "在幸运活动中获得", titleColor: .titleColor_white, titleFont: UIFont.systemFont(ofSize: 11), image: nil)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
//        btn.addTarget(self, action: #selector(toNameTapAction), for: .touchUpInside)
        return btn
    }()
    
    // 礼物
    let giftImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    
    // 数量
    let giftNumLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "X1", textColor: .titleColor_yellow, font: .titleFont_11)
        return label
    }()
    // 按钮
    lazy var cicikButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: UIImage(named: "float_say_hi"))
        btn.addTarget(self, action: #selector(cilicTapAction), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.creatUI()
    }
    
    func creatUI() {
        addSubviews([bgImageView, tipLabel, headerFromImageView, nameFromButton, nameToBtn, giftImageView, giftNumLabel, cicikButton])
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.centerY.equalToSuperview().offset(-3)
        }
        
        headerFromImageView.layer.cornerRadius = 8
        headerFromImageView.layer.masksToBounds = true
        headerFromImageView.snp.makeConstraints { make in
            make.left.equalTo(tipLabel.snp.right).offset(3)
            make.centerY.equalTo(tipLabel)
            make.width.height.equalTo(16)
        }
        
        nameFromButton.snp.makeConstraints { make in
            make.left.equalTo(headerFromImageView.snp.right).offset(1)
            make.centerY.equalTo(headerFromImageView)
            make.width.equalTo(66)
        }
        
        nameToBtn.snp.makeConstraints { make in
            make.left.equalTo(nameFromButton.snp.right).offset(2)
            make.centerY.equalTo(headerFromImageView)
//            make.width.equalTo((66))
        }
        
        giftImageView.snp.makeConstraints { make in
            make.left.equalTo(nameToBtn.snp.right).offset(4)
            make.centerY.equalTo(headerFromImageView)
            make.width.height.equalTo(18)
        }
        
        giftNumLabel.snp.makeConstraints { make in
            make.left.equalTo(giftImageView.snp.right).offset(2)
            make.centerY.equalTo(headerFromImageView)
        }
        
        cicikButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(headerFromImageView)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
    }
    
    @objc func fromNameTapAction() {
        debugPrint("点击昵称")
    }
    
    @objc func cilicTapAction() {
        debugPrint("点击了打招呼")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}

// MARK: LQPlayableAnimation流程控制
extension FSBigGiftView {
    
    func start(model: LQAnimationModel) {
        let animation = self.createAnimation(for: self)
        self.layer.removeAnimation(forKey: floatingScreenAnimationKey)
        self.layer.add(animation, forKey: floatingScreenAnimationKey)
        self.delegate?.animationDidStart(model)
        
        // 真是不想去监听动画了，偷懒
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
            self.stop(model: model)
        }
    }
    
    func stop(model: LQAnimationModel) {
//        self.layer.removeAnimation(forKey: floatingScreenAnimationKey)
        self.delegate?.animationDidStop(model)
    }
}

#Preview {
    let view = UIView()
    let contentView = FSBigGiftView()
    
    contentView.frame = CGRectMake((ScreenConst.width - 345)/2, 200, 345, 39)
    view.addSubview(contentView)
    return view
}
