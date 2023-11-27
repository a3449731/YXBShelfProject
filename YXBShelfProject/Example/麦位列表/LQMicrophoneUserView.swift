//
//  LQMicrophoneView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit
import SDWebImage

class LQMicrophoneUserView: UIView {
    
    // 麦波
    let rippleView: LQYinLiangView = {
        LQYinLiangView(frame: .zero)
    }()
    
    // 底图
    let iconButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: UIImage(named: "CUYuYinFang_zhibojian_kongxian"))
        return btn
    }()
    
    // 头像 + 头像框
    lazy var headerView: HeaderStaticView = {
        let view = HeaderStaticView()
        return view
    }()
    
    // 喇叭，闭麦状态下显示，开麦的时候隐藏
    let voiceImageView: UIImageView = {
        let view = MyUIFactory.commonImageView(name: "CUYuYinFang_roomDetail_bimai", placeholderImage: nil)
        view.isHidden = true
        return view
    }()
            
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([rippleView, iconButton, headerView, voiceImageView])
        
        rippleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(1.5)
        }
        
        iconButton.snp.makeConstraints { make in
            make.width.height.equalTo(50.fitScale())
            make.center.equalToSuperview()
        }
        
        headerView.headerImageView.layer.cornerRadius = 25.fitScale()
        headerView.headerImageView.masksToBounds = true
        headerView.snp.makeConstraints { make in
            make.width.height.equalTo(50.fitScale())
            make.center.equalToSuperview()
        }
        
        voiceImageView.snp.makeConstraints { make in
            make.right.equalTo(headerView)
            make.bottom.equalTo(headerView)
            make.width.height.equalTo(12.fitScale())
        }
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
