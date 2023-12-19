//
//  FSBigGiftView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/23.
//

import UIKit
import YYText

/// 大礼物飘屏的view
class FSBigGiftView: FloatingBaseView, LQFloatAnimation {
//    weak var delegate: LQAnimationDelegate?
    
    private let floatingScreenAnimationKey = "FloatingScreenAnimation"
        
    // 持有数据只是为了做操作的时候用
    var model: LQAnimationModel?
    
    // 背景图
    let bgImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "float_big_type_1", placeholderImage: nil)
        return imageView
    }()
    
    let tipLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "恭喜", textColor: .titleColor_white, font: UIFont.systemFont(ofSize: 10))
        return label
    }()
    
    // 送的头像
    let headerFromImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "CUYuYinFang_login_logo", placeholderImage: nil)
        return imageView
    }()
    // 送的昵称
    lazy var nameFromButton: UILabel = {
        let label = MyUIFactory.commonLabel(text: "用户是你阿萨德阿打发", textColor: .titleColor_yellow, font: .titleFont_10)
        return label
//        let btn = MyUIFactory.commonButton(title: "用户昵称昵称啊啊发", titleColor: .titleColor_yellow, titleFont: .titleFont_11, image: nil)
//        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
////        btn.addTarget(self, action: #selector(fromNameTapAction), for: .touchUpInside)
//        btn.isUserInteractionEnabled = false
//        return btn
    }()

    // 收到的昵称
    lazy var nameToBtn: UIButton = {
        let btn = MyUIFactory.commonButton(title: "在幸运活动中获得", titleColor: .titleColor_white, titleFont: UIFont.systemFont(ofSize: 10), image: nil)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail;//  设置尾部省略
//        btn.addTarget(self, action: #selector(toNameTapAction), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
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
        addSubviews([bgImageView, tipLabel, headerFromImageView, nameFromButton, nameToBtn, giftNumLabel, cicikButton])
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.centerY.equalToSuperview().offset(-3)
        }
        
        headerFromImageView.layer.cornerRadius = 6.5
        headerFromImageView.layer.masksToBounds = true
        headerFromImageView.snp.makeConstraints { make in
            make.left.equalTo(tipLabel.snp.right).offset(3)
            make.centerY.equalTo(tipLabel)
            make.width.height.equalTo(13)
        }
        
        nameFromButton.snp.makeConstraints { make in
            make.left.equalTo(headerFromImageView.snp.right).offset(3)
            make.centerY.equalTo(headerFromImageView)
//            make.width.equalTo(66)
        }
        
        nameToBtn.snp.makeConstraints { make in
            make.left.equalTo(nameFromButton.snp.right).offset(3)
            make.centerY.equalTo(headerFromImageView)
//            make.width.equalTo((66))
        }
        
        /*
        giftImageView.snp.makeConstraints { make in
            make.left.equalTo(nameToBtn.snp.right).offset(4)
            make.centerY.equalTo(headerFromImageView)
            make.width.height.equalTo(18)
        }
        */
        
        giftNumLabel.snp.makeConstraints { make in
            make.left.equalTo(nameToBtn.snp.right).offset(2)
            make.centerY.equalTo(headerFromImageView)
        }
        
        cicikButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(headerFromImageView)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
    }
    
    /*
    @objc func fromNameTapAction() {
        debugPrint("点击昵称")
    }
    
    @objc func cilicTapAction() {
        debugPrint("点击了打招呼")
    }
    */
    
    // 点击了整个条目
    @objc func tapAllItem(_ tap: UITapGestureRecognizer) {
        debugPrint("点击了整个条目")
        if let currentVc = UIApplication.shared.getCurrentUIController() {
            // 跳网页
//            if model?.floatType == .active,
//               let url = model?.activityUrl {
//                let vc = LQWebViewController(url: url, withIsNavBar: true, withNavTitle: "")
//                vc.hidesBottomBarWhenPushed = true
//                currentVc.navigationController?.pushViewController(vc, animated: true)
//                return
//            }
//            
//            // 跳房间
//            if let houseNo = model?.houseId {
//                MyTool.setupMakeJoinRoomWith(fromVc: currentVc, dict: ["id": houseNo])
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
    
    // MARK: LQPlayableAnimation流程控制
    override func start(model: LQAnimationModel) {
        self.model = model
        
        if let floatType = model.floatType,
           let name = floatType.bgImageName(nobbleLevel: model.vipLevel ?? 0, scopeFloat: 0) {
            self.bgImageView.image = UIImage(named: name)
            self.headerFromImageView.sd_setImage(with: URL(string: model.headImg), placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
//            self.nameFromButton.setTitle(model.nickname, for: .normal)
            self.nameFromButton.text = model.nickname?.truncated(toLength: 5)
//            self.giftImageView.sd_setImage(with: URL(string: model.gift?.giftImg), placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
            self.giftNumLabel.text = "\(model.gift?.giftName ?? "")X\(model.gift?.num ?? "")"
            
            if floatType == .bigGift {
                self.nameToBtn.setTitle("在幸运活动中获得", for: .normal)
                self.cicikButton.setImage(UIImage(named: "float_sea"), for: .normal)
            }
            
            if floatType == .active {
                self.cicikButton.setImage(UIImage(named: "float_join"), for: .normal)
                
//                self.nameToBtn.setTitle("在\(model.activityName ?? "")中获得", for: .normal)
                
                let att = NSMutableAttributedString(string: "")
                
                let att_1 = NSMutableAttributedString(string: "在")
                att_1.yy_font = UIFont.systemFont(ofSize: 11)
                att_1.yy_color = .titleColor_white
                att.append(att_1)
                
                let att_3 = NSMutableAttributedString(string: model.activityName ?? "")
                att_3.yy_font = UIFont.systemFont(ofSize: 11)
                att_3.yy_color = .titleColor_yellow
                att.append(att_3)
                
                let att_2 = NSMutableAttributedString(string: "中获得")
                att_2.yy_font = UIFont.systemFont(ofSize: 11)
                att_2.yy_color = .titleColor_white
                att.append(att_2)
                self.nameToBtn.setAttributedTitle(att, for: .normal)
            }
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
    let contentView = FSBigGiftView()
    
    contentView.frame = CGRectMake((ScreenConst.width - 345)/2, 200, 345, 39)
    
    let att = NSMutableAttributedString(string: "")
    
    let att_1 = NSMutableAttributedString(string: "在")
    att_1.yy_font = UIFont.systemFont(ofSize: 11)
    att_1.yy_color = .titleColor_white
    att.append(att_1)
    
    let att_3 = NSMutableAttributedString(string: "时光扭蛋机")
    att_3.yy_font = UIFont.systemFont(ofSize: 11)
    att_3.yy_color = .titleColor_yellow
    att.append(att_3)
    
    let att_2 = NSMutableAttributedString(string: "中获得")
    att_2.yy_font = UIFont.systemFont(ofSize: 11)
    att_2.yy_color = .titleColor_white
    att.append(att_2)
    contentView.nameToBtn.setAttributedTitle(att, for: .normal)
    
    view.addSubview(contentView)
    return view
}
