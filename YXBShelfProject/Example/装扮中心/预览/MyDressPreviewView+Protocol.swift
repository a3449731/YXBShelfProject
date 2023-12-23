//
//  MyDressPreviewView+Protocol.swift
//  CUYuYinFang
//
//  Created by yangxiaobin on 2023/10/21.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import UIKit
import SDWebImage

/// 装扮协议
protocol DressPreviewProtocol {
    /// 添加
    func addTo(superView: UIView, type: MSDressType?)
    /// 移除
    func removeForm(superView: UIView)
    /// 展示头像
    func showHeader(type: MSDressType?)
    /// 展示静态图片
    func showStaticImage(urlString: String, type: MSDressType?)
    /// 展示动画
    func showAnimation(selectModel: MSDressModel?, type: MSDressType?)
    /// 停止动画
    func stopAnimation()
}

extension DressPreviewProtocol where Self: MSDressPreviewView {
    func addTo(superView: UIView, type: MSDressType?) {
        superView.addSubview(self)
        self.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.staticImageView.image = nil
        
        // 头像
        self.headerImageView.isHidden = true
        if type == .header {
            self.headerImageView.isHidden = false
        }
        
        // 坐骑
        self.tipLabel.isHidden = true
        if type == .car {
            self.tipLabel.isHidden = false
        }
        
        // 入场特效
        if type == .enter {
            
        }
        
        // 调整特效尺寸
        self.playButton.isHidden = true
        if type == .enter || type == .car {
            self.playButton.isHidden = false
            self.effectsView.snp.remakeConstraints { make in
                // 这里的left和top是一个偷懒的方式，是依赖外面的约束值了，搞鬼。
                make.left.equalToSuperview().offset(-15.fitScale())
                make.top.equalToSuperview().offset(-ScreenConst.navStatusBarHeight - 10.fitScale())
                make.width.equalTo(ScreenConst.width)
                make.height.equalTo(ScreenConst.height)
            }
            
        } else if type == .header {
            self.effectsView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(110)
            }
        } else {
            self.effectsView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(110)
            }
        }
        
        
//        // 聊天气泡
        if type == .bunddle {
            self.staticImageView.contentMode = .scaleAspectFit
            self.staticImageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(50)
            }
        } else {
            self.staticImageView.contentMode = .scaleAspectFit
            self.staticImageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(80 * 1.25)
            }
        }
//
//        // 勋章气泡
//        if type == .medal {
//            self.headerFrameView.isHidden = true
//            self.headerImageView.cornerRadius(0)
//            self.headerImageView.contentMode = .scaleAspectFit
//            self.headerImageView.snp.remakeConstraints { make in
//                make.center.equalToSuperview()
//                make.height.equalTo(40)
//            }
//        }
    }
    
    func removeForm(superView: UIView) {
        self.removeFromSuperview()
    }
    
    func showHeader(type: MSDressType?) {
        if type == .bunddle || type == .car {
            
        } else {
            self.headerImageView.sd_setImage(with: URL(string: UserConst.headImg))
        }
    }
    
    func showStaticImage(urlString: String, type: MSDressType?) {
//        if type == .car {
            
//        } else {
            debugPrint("显示静态图片,", urlString)
            self.staticImageView.sd_setImage(with: URL(string: urlString))
//        }
    }
    
    func showAnimation(selectModel: MSDressModel?, type: MSDressType?) {
        if type == .bunddle {
            self.headerImageView.sd_setImage(with: URL(string: selectModel?.img ?? ""))
        } else {
            self.tipLabel.isHidden = true
            self.effectsView.stopAnimating()
            guard let url = selectModel?.texiao else {return}
            if url.count > 0 {
                
                if type == .enter {
                    self.effectsView.playUrl(url, nickName: "你爸爸")
                } else {
                    self.effectsView.playUrl(url)
                }
                
                // 如果是入场横幅，要注入昵称和头像
//                if type == .join {
//                    let attName = NSMutableAttributedString(string: userModel?.nickname ?? "")
//                    attName.yy_color = .red
//                    attName.yy_font = UIFont.pingFang(fontSize: 22, style: .regular)
//                    let attJoin = NSMutableAttributedString(string: "进入直播间")
//                    attJoin.yy_color = .white
//                    attJoin.yy_font = UIFont.pingFang(fontSize: 22, style: .regular)
//                    self.headerFrameView.svgaPlayerView.setAttributedText(attName, forKey: "01")
//                    self.headerFrameView.svgaPlayerView.setAttributedText(attJoin, forKey: "02")
//
//                    let newIcon = userModel?.headPicture ?? ""
//                    SDWebImageManager.shared.loadImage(with: URL(string: newIcon), progress: nil) {[weak self]  image, data, error, type, result, url in
//                        self?.headerFrameView.svgaPlayerView.setImage(image, forKey: "03")
//                    }
//                }
            }
        }
    }
    
    func stopAnimation() {
        self.effectsView.stopAnimating()
    }
    
    
    // 专门给购买页面使用的方法,调整title的位置
//    func adjustBuyTitleLabel() {
//        self.buyTipLabel.snp.remakeConstraints { make in
//            make.top.equalTo(self.headerImageView.snp.bottom).offset(25)
////            make.top.equalTo(self.headerFrameView.snp.bottom).offset(15)
//            make.centerX.equalToSuperview()
//            make.left.greaterThanOrEqualToSuperview().offset(20)
//            make.right.lessThanOrEqualToSuperview().offset(-20)
//        }
//    }
    
    // 专门给购买页面使用的方法,调整title的文本
//    func showBuyTitle(text: String) {
//        // 入场特效
//        self.buyTipLabel.isHidden = false
//        self.buyTipLabel.text = text
//    }
    
}
