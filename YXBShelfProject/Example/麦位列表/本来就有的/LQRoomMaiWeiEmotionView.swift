//
//  LQRoomMaiWeiEmotionView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/11.
//

import UIKit
import SDWebImage

class LQRoomMaiWeiEmotionView: UIView {
    var roomEmotionUrl: String? {
        didSet {
            emotionImgView.isHidden = false
            SDWebImageManager.shared.loadImage(with: URL(string: roomEmotionUrl), options: .retryFailed, progress: nil, completed: { [weak self] (image, data, error, cacheType, finished, url) in
                if image?.sd_isAnimated ?? false {
                    self?.emotionImgView.image = image
                    self?.emotionImgView.isHidden = false

                    DispatchQueue.main.asyncAfter(deadline: .now() + Double((image?.images?.count ?? 0)) * 0.1) {
                        self?.emotionImgView.image = nil
                        self?.emotionImgView.isHidden = true
                    }
                }
            })
        }
    }
    
    var emotionImgView: SDAnimatedImageView = SDAnimatedImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        creatSubView()
    }
    
    func creatSubView() {
        emotionImgView = SDAnimatedImageView(frame: bounds)
        emotionImgView.contentMode = .scaleAspectFill
        emotionImgView.isUserInteractionEnabled = true
        emotionImgView.shouldCustomLoopCount = true
        emotionImgView.animationRepeatCount = 1
        addSubview(emotionImgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
