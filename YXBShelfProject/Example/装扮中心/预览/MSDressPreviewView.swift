//
//  MSDressPreviewView.swift
//  CUYuYinFang
//
//  Created by 蓝鳍互娱 on 2023/10/21.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import UIKit

class MSDressPreviewView: UIView, DressPreviewProtocol {
    
//    public lazy var effectPreviewLabel: GradientLabel = {
//        let label = GradientLabel()
////        label.makeGradient([UIColor(hex: 0xFE8692), UIColor(hex: 0x447AF6)], direction: .fromLeftToRight)
//        label.textAlignment = .center
//        label.font = UIFont.pingFang(fontSize: 12, style: .regular)
//        label.textColor = .white
//        label.text = "效果预览"
//        return label
//    }()
    
    /// 头像框的view
    public lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.pingFang(fontSize: 12, style: .regular)
        label.textColor = UIColor(hex: 0x7E849D)
//        label.text = "来挑选个座驾吧~"
        return label
    }()
    
    /// svga的view
    public lazy var effectsView: PlayEffectsView = {
        let view = PlayEffectsView()
        // 只播放一次
//        view.svgaPlayerView.loops = 1
        view.delegate = self
        return view
    }()
    
    public lazy var headerImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    // 放静态图的
    public lazy var staticImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    public lazy var playButton: UIButton = {
        let btn = MyUIFactory.commonButton(title: nil, titleColor: nil, titleFont: nil, image: UIImage(named: "wode_dress_play"))
        btn.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        return btn
    }()
    
    /// 头像框的view
//    public lazy var buyTipLabel: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.font = UIFont.pingFang(fontSize: 16, style: .regular)
//        label.textColor = .white
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.addSubview(effectPreviewLabel)
        self.addSubview(tipLabel)
        self.addSubview(headerImageView)
        self.addSubview(effectsView)
        self.addSubview(staticImageView)
        self.addSubview(playButton)
//        self.addSubview(buyTipLabel)
                
//        effectPreviewLabel.cornerRadius(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 13)
//        effectPreviewLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(0)
//            make.left.equalToSuperview()
//            make.width.equalTo(89)
//            make.height.equalTo(26)
//        }
        
        tipLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        effectsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(110)
        }
        
        headerImageView.layerBorderWidth = 40
        headerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        staticImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(90)
        }
    }
    
    // 座驾和入场特效会展示一个按钮，点了之后播放动画
    @objc func playButtonAction() {
        NotificationCenter.default.post(name: NSNotification.Name("clickPlayButton"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}

extension MSDressPreviewView: PlayEffectsViewDelegate {
    func effects(startAnimation: PlayEffectsView) {
        self.playButton.isHidden = true
        self.staticImageView.isHidden = true
    }
    
    func effects(stopAnimation: PlayEffectsView) {
        self.playButton.isHidden = false
        self.staticImageView.isHidden = false
    }
}
