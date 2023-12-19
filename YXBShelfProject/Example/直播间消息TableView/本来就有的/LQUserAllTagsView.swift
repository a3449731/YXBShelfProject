//
//  LQUserAllTagsView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/14.
//

import UIKit

/// 用户的标签容器，一下字展示
@objc class LQUserAllTagsView: UIView {
    
    // 容器
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = self.spacing
        return stackView
    }()
    
    // 间距
    var spacing: CGFloat = 4 {
        didSet {
            hStack.spacing = spacing
        }
    }
    
    // 性别
    @objc lazy var sexImageView: UIImageView = {
        let imgView = MyUIFactory.commonImageView(placeholderImage: nil)
        return imgView
    }()
    
    // 贵族特效图标，有可能是webp链接
    @objc let nobleImageView: UIImageView = {
        let imgView = MyUIFactory.commonImageView(placeholderImage: nil)
        return imgView
    }()
    
    // 财富等级
    @objc lazy var richView: HonourTagView = {
        let view = HonourTagView()
        view.isHidden = true
        return view
    }()
    
    // 魅力等级
    @objc lazy var charmView: HonourTagView = {
        let view = HonourTagView()
        view.isHidden = true
        return view
    }()
    
    // vip等级
    @objc lazy var vipImageView: UIImageView = {
        let imgView = MyUIFactory.commonImageView(placeholderImage: nil)
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hStack)
        hStack.addArrangedSubviews([sexImageView, nobleImageView, richView, charmView, vipImageView])
                
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sexImageView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(16)
        }
        
        richView.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(16)
        }
        
        charmView.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(16)
        }
        
        nobleImageView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(16)
        }
        
        vipImageView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(16)
        }
    }

    // 设置图片
    @objc func setPicturs(sexImageUrl: String?,
                          nobleImageUrl: String?,
                          richImageUrl: String?,
                          charmImageUrl: String?,
                          vipImageUrl: String?) {
        sexImageView.isHidden = (sexImageUrl == nil || sexImageUrl!.isEmpty)
        vipImageView.isHidden = (vipImageUrl == nil || vipImageUrl!.isEmpty)
        nobleImageView.isHidden = (nobleImageUrl == nil || nobleImageUrl!.isEmpty)
        richView.isHidden = (richImageUrl == nil || richImageUrl!.isEmpty)
        charmView.isHidden = (charmImageUrl == nil || charmImageUrl!.isEmpty)
        
        if let sexImageUrl = sexImageUrl {
            if sexImageUrl.hasPrefix("http") {
                sexImageView.sd_setImage(with: URL(string: sexImageUrl))
            } else {
                sexImageView.image = UIImage(named: sexImageUrl)
            }
        }
                              
        if let vipImageUrl = vipImageUrl {
            if vipImageUrl.hasPrefix("http") {
                vipImageView.sd_setImage(with: URL(string: vipImageUrl))
            } else {
                vipImageView.image = UIImage(named: vipImageUrl)
            }
        }
        
        if let nobleImageUrl = nobleImageUrl {
            if nobleImageUrl.hasPrefix("http") {
                nobleImageView.sd_setImage(with: URL(string: nobleImageUrl))
            } else {
                nobleImageView.image = UIImage(named: nobleImageUrl)
            }
        }
        
        if let richImageUrl = richImageUrl {
            if richImageUrl.hasPrefix("http") {
                richView.imageUrl = richImageUrl
            } else {
                richView.imageName = richImageUrl
            }
        }
        
        if let charmImageUrl = charmImageUrl {
            if charmImageUrl.hasPrefix("http") {
                charmView.imageUrl = charmImageUrl
            } else {
                charmView.imageName = charmImageUrl
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    
    let label = MyUIFactory.commonLabel(text: "迷途熊迷途熊迷assas洒水飒飒飒途熊迷途熊", textColor: nil)
    contentView.addSubview(label)
    
    label.backgroundColor = .red
    label.snp.makeConstraints { make in
        make.top.equalTo(100)
        make.left.equalTo(70)
//        make.width.greaterThanOrEqualTo(150)
    }
    
    let firstView = LQUserAllTagsView(frame: .zero)
    firstView.backgroundColor = .yellow
    //    firstView.frame = CGRectMake(0, 150, ScreenConst.width, 46.fitScale())
    // 几个图标，讲道理我应该在viewModel中取整齐这些的。
    var host: String?
    var house: String?
    var assistant: String?
    var rich: String?
    var charm: String?
    var noble: String?
    host = "CUYuYinFang_fanzhuHead"
    house = ""
    assistant = ""
    rich = VipPictureConfig.richBubble(level: 20)
    charm = VipPictureConfig.charmBubble(level: 10)
    noble = VipPictureConfig.nobleBubble(level: 7)
    
    firstView.setPicturs(sexImageUrl: host, nobleImageUrl: noble, richImageUrl: rich, charmImageUrl: charm, vipImageUrl: nil)
    firstView.richView.title = "12"
    firstView.charmView.title = "33"
    
    contentView.addSubview(firstView)
    firstView.snp.makeConstraints { make in
        make.left.equalTo(label.snp.right)
        make.centerY.equalTo(label)
        make.right.lessThanOrEqualToSuperview().offset(-20).priority(.required)
        make.height.equalTo(20)
    }
    
    return contentView
}

