//
//  FloatingScreenView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/22.
//

import UIKit

class FloatingBaseView: UIView, LQPlayableAnimation {
    weak var delegate: LQAnimationDelegate?
    
    func start(model: LQAnimationModel) {
        
    }
    
    func stop(model: LQAnimationModel) {
        
    }
}


/// 飘屏的view
class FloatingScreenView: FloatingBaseView, LQFloatAnimation {
//    weak var delegate: LQAnimationDelegate?
    
    private let floatingScreenAnimationKey = "FloatingScreenAnimation"
        
    // 背景图
    let bgImageView: UIImageView = {
//        "float_nobble_type_1"
//        "float_nobble_type_2"
//        "float_gift_type_1"
//        "float_gift_type_1"
//        "float_gift_type_2"
//        "float_gift_type_3"
//        "float_gift_type_4"
//        "float_gift_type_5"
//        "float_big_type_1"
        let imageView = MyUIFactory.commonImageView(name: "float_gift_type_1", placeholderImage: nil, contentMode: .scaleToFill)
        return imageView
    }()
    // 送的头像
    let headerFromImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 送的昵称
    lazy var nameFromButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: "用户昵称称金合欢花", titleColor: .titleColor_yellow, titleFont: .titleFont_11, image: nil)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
        btn.addTarget(self, action: #selector(fromNameTapAction), for: .touchUpInside)
        return btn
    }()
    let tipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "打赏", textColor: .titleColor_white, font: .titleFont_11)
        return label
    }()
    // 收到的头像
    let headerToImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 收到的昵称
    lazy var nameToBtn: UIButton = {
        let btn = MyUIFactory.commonButton(title: "用户昵称称哈哈哈哈", titleColor: .titleColor_yellow, titleFont: .titleFont_11, image: nil)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
        btn.addTarget(self, action: #selector(toNameTapAction), for: .touchUpInside)
        return btn
    }()
    // 礼物
    let giftImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 数量
    let giftNumLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "X12", textColor: .titleColor_yellow, font: .titleFont_11)
        return label
    }()
    // 按钮
    lazy var cicikButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: UIImage(named: "float_sea"))
        btn.addTarget(self, action: #selector(cilicTapAction), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.creatUI()
    }
    
    func creatUI() {
        addSubviews([bgImageView, headerFromImageView, nameFromButton, tipLabel, headerToImageView, nameToBtn, giftImageView, giftNumLabel, cicikButton])
        
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(336.fitScale())
            make.height.equalTo(33.fitScale())
        }
        
        headerFromImageView.layer.cornerRadius = 8
        headerFromImageView.layer.masksToBounds = true
        headerFromImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(43)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        nameFromButton.snp.makeConstraints { make in
            make.left.equalTo(headerFromImageView.snp.right).offset(1)
            make.centerY.equalToSuperview()
            make.width.equalTo(66)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(nameFromButton.snp.right)
            make.centerY.equalToSuperview()
        }
        
        headerToImageView.layer.cornerRadius = 8
        headerToImageView.layer.masksToBounds = true
        headerToImageView.snp.makeConstraints { make in
            make.left.equalTo(tipLabel.snp.right).offset(3)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        nameToBtn.snp.makeConstraints { make in
            make.left.equalTo(headerToImageView.snp.right).offset(1)
            make.centerY.equalToSuperview()
            make.width.equalTo((66))
        }
        
        giftImageView.snp.makeConstraints { make in
            make.left.equalTo(nameToBtn.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        giftNumLabel.snp.makeConstraints { make in
            make.left.equalTo(giftImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }
        
        cicikButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
    }
    
    @objc func fromNameTapAction() {
        debugPrint("点击昵称")
    }
    
    @objc func toNameTapAction() {
        debugPrint("点击昵称")
    }
    
    @objc func cilicTapAction() {
        debugPrint("点击了去围观")
    }
    
    // MARK: LQPlayableAnimation流程控制
    override func start(model: LQAnimationModel) {
        let animation = self.createAnimation(for: self)
        self.layer.removeAnimation(forKey: floatingScreenAnimationKey)
        self.layer.add(animation, forKey: floatingScreenAnimationKey)
        self.delegate?.animationDidStart(model)
        
        // 真是不想去监听动画了，偷懒
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
            self.stop(model: model)
        }
    }
    
    override func stop(model: LQAnimationModel) {
//        self.layer.removeAnimation(forKey: floatingScreenAnimationKey)
        self.delegate?.animationDidStop(model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}


#Preview {
    let view = UIView()
    let contentView = FloatingScreenView()
    
    contentView.frame = CGRectMake(16.fitScale(), 200, ScreenConst.width - 32.fitScale(), 33.fitScale())
    view.addSubview(contentView)
    return view
}
