//
//  PKReadyGifView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/9.
//

import UIKit
import SDWebImage

// 播放一次gif的示例
class PKReadyGifView: UIView {
    // 创建SDAnimatedImageView实例
    let localImageView = SDAnimatedImageView()
    // 网络
    let networkImageView = SDAnimatedImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: - 本地gif, 播放一次
        addSubview(localImageView)
        localImageView.backgroundColor = .red
        localImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
//            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        // 设置动画播放次数为1
        localImageView.shouldCustomLoopCount = true
        localImageView.animationRepeatCount = 1
        
        // 加载本地GIF图片
        if let gifImage = SDAnimatedImage(named: "pkReadyGo.gif") {
            // 设置imageView的动画图像
            localImageView.image = gifImage
            // 开始播放动画
            localImageView.startAnimating()
        }
        
        // MARK: - 网络gif，播放一次
        addSubview(networkImageView)
        networkImageView.backgroundColor = .red
        networkImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        // 设置动画播放次数为1
        networkImageView.shouldCustomLoopCount = true
        networkImageView.animationRepeatCount = 1
        // 使用sd_setImage方法加载和显示网络上的GIF图片
//    https:lanqi123.oss-cn-beijing.aliyuncs.com/memePack/%E6%91%B8%E6%91%B8%E5%A4%B4.gif
//    https://lanqi123.oss-cn-beijing.aliyuncs.com/file/36816_76574d3722784a2985a985d064a2c0dc_ios_1698902636.gif
        networkImageView.sd_setImage(with: URL(string: "https:lanqi123.oss-cn-beijing.aliyuncs.com/memePack/%E6%91%B8%E6%91%B8%E5%A4%B4.gif"), completed: { [weak self] (image, error, cacheType, url) in
            if let error = error {
                print("加载网络GIF图片失败：", error.localizedDescription)
            } else {
                // 开始播放动画
                self?.networkImageView.startAnimating()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    PKReadyGifView()
}

