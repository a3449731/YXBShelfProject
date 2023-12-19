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
    
    // 持有数据只是为了做操作的时候用
    var model: LQAnimationModel?
        
    // 背景图
    let bgImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "float_gift_type_1", placeholderImage: nil, contentMode: .scaleToFill)
        return imageView
    }()
    // 送的头像
    let headerFromImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 送的昵称
    lazy var nameFromButton: UILabel = {
        let label = MyUIFactory.commonLabel(text: "用户", textColor: .titleColor_yellow, font: .titleFont_10)
        return label

//        let btn = MyUIFactory.commonButton(title: "用户昵称称金合欢花", titleColor: .titleColor_yellow, titleFont: .titleFont_11, image: nil)
//        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
////        btn.addTarget(self, action: #selector(fromNameTapAction), for: .touchUpInside)
//        btn.isUserInteractionEnabled = false
//        return btn
    }()
    let tipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "打赏", textColor: .titleColor_white, font: .titleFont_10)
        return label
    }()
    // 收到的头像
    let headerToImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 收到的昵称
    lazy var nameToBtn: UILabel = {
        let label = MyUIFactory.commonLabel(text: "用户", textColor: .titleColor_yellow, font: .titleFont_10)
        return label
//        let btn = MyUIFactory.commonButton(title: "用户昵称称哈哈哈哈", titleColor: .titleColor_yellow, titleFont: .titleFont_11, image: nil)
//        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
////        btn.addTarget(self, action: #selector(toNameTapAction), for: .touchUpInside)
//        btn.isUserInteractionEnabled = false
//        return btn
    }()
    // 礼物
    /*
    let giftImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    */
    // 数量
    let giftNumLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "X1", textColor: .titleColor_yellow, font: .titleFont_10)
        return label
    }()
    // 按钮
    lazy var cicikButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: UIImage(named: "float_sea"))
//        btn.addTarget(self, action: #selector(cilicTapAction), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
        
        // 为整个条目添加手势
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAllItem(_ :))))
    }
    
    func creatUI() {
        addSubviews([bgImageView, headerFromImageView, nameFromButton, tipLabel, headerToImageView, nameToBtn, giftNumLabel, cicikButton])
        
        bgImageView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.width.equalTo(336.fitScale())
//            make.height.equalTo(33.fitScale())
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        headerFromImageView.layer.cornerRadius = 6.5
        headerFromImageView.layer.masksToBounds = true
        headerFromImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(38.fitScale())
            make.centerY.equalToSuperview()
            make.width.height.equalTo(13)
        }
        
        nameFromButton.snp.makeConstraints { make in
            make.left.equalTo(headerFromImageView.snp.right).offset(3)
            make.centerY.equalToSuperview()
//            make.width.equalTo(66)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(nameFromButton.snp.right)
            make.centerY.equalToSuperview()
        }
        
        headerToImageView.layer.cornerRadius = 6.5
        headerToImageView.layer.masksToBounds = true
        headerToImageView.snp.makeConstraints { make in
            make.left.equalTo(tipLabel.snp.right).offset(3)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(13)
        }
        
        nameToBtn.snp.makeConstraints { make in
            make.left.equalTo(headerToImageView.snp.right).offset(3)
            make.centerY.equalToSuperview()
//            make.width.equalTo((66))
        }
        
        /*
        giftImageView.snp.makeConstraints { make in
            make.left.equalTo(nameToBtn.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        */
        
        giftNumLabel.snp.makeConstraints { make in
            make.left.equalTo(nameToBtn.snp.right).offset(2)
            make.centerY.equalToSuperview()
        }
        
        cicikButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
    }
    
    /*
    @objc func fromNameTapAction() {
        debugPrint("点击昵称")
        // 去个人资料
        if let userId = model?.tippingUser?.id  {
            let vc = MSUserDetailMainVC()
            vc.uid = userId
            vc.hidesBottomBarWhenPushed = true
            let currentVc = UIApplication.shared.getCurrentUIController()
            currentVc?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func toNameTapAction() {
        debugPrint("点击昵称")
        if let userId = model?.byTippingUser?.id  {
            let vc = MSUserDetailMainVC()
            vc.uid = userId
            vc.hidesBottomBarWhenPushed = true
            let currentVc = UIApplication.shared.getCurrentUIController()
            currentVc?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cilicTapAction() {
        debugPrint("点击了去围观")
        if let currentVc = UIApplication.shared.getCurrentUIController(),
           let houseNo = model?.houseId {
            MyTool.setupMakeJoinRoomWith(fromVc: currentVc, dict: ["id": houseNo])
        }
    }
    */
    
    // 点击了整个条目
    @objc func tapAllItem(_ tap: UITapGestureRecognizer) {
        debugPrint("点击了整个条目")
        if let currentVc = UIApplication.shared.getCurrentUIController(),
           let houseNo = model?.houseId {
//            MyTool.setupMakeJoinRoomWith(fromVc: currentVc, dict: ["id": houseNo])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
    
    // MARK: 流程控制
    override func start(model: LQAnimationModel) {
        self.model = model
        
        if model.floatType == .gift,
           let type = model.scopeFloat {
            self.bgImageView.image = UIImage(named: type.bgImageName)
            self.headerFromImageView.sd_setImage(with: URL(string: model.tippingUser?.headImg), placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
//            self.nameFromButton.setTitle(model.tippingUser?.nickname, for: .normal)
            self.nameFromButton.text = model.tippingUser?.nickname?.truncated(toLength: 5)
            self.headerToImageView.sd_setImage(with: URL(string: model.byTippingUser?.headImg), placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
//            self.nameToBtn.setTitle(model.byTippingUser?.nickname, for: .normal)
            self.nameToBtn.text = model.byTippingUser?.nickname?.truncated(toLength: 5)
//            self.giftImageView.sd_setImage(with: URL(string: model.img), placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
            self.giftNumLabel.text = "\(model.giftName ?? "")X\(model.num ?? "")"
        }
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
}



#Preview {
    let view = UIView()
    let contentView = FloatingScreenView()
    
    contentView.frame = CGRectMake(16.fitScale(), 200, ScreenConst.width - 32.fitScale(), 33.fitScale())
    view.addSubview(contentView)
    return view
}
