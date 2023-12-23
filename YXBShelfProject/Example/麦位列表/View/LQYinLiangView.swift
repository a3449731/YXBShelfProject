//
//  LQYinLiangView.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/24.
//

import UIKit

class LQYinLiangView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  这是用动画做的脉波，先不用了。直接用webp图片
/*
class LQYinLiangView: UIView {
    
    private var animationLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor?.setFill()
        UIRectFill(rect)
        // 波纹数
        let pulsingCount = 3
        // 波纹扩散速度
        let animationDuration = 3.0
        if animationLayer != nil {
            animationLayer.removeFromSuperlayer()
            animationLayer = nil
        }
        animationLayer = CALayer()
        for i in 0..<pulsingCount {
            // 创建波纹
            let pulsingLayer = CALayer()
            pulsingLayer.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
            pulsingLayer.cornerRadius = rect.size.height / 2.0
            pulsingLayer.borderColor = UIColor(red: 130/255, green: 255/255, blue: 245/255, alpha: 1).cgColor
            pulsingLayer.borderWidth = 1
            let defaultCurve = CAMediaTimingFunction(name: .default)
            // 动画组
            let animationGroup = CAAnimationGroup()
            animationGroup.fillMode = .backwards
            animationGroup.beginTime = CACurrentMediaTime() + Double(i) * animationDuration / Double(pulsingCount)
            animationGroup.duration = animationDuration
            animationGroup.repeatCount = .greatestFiniteMagnitude
            animationGroup.timingFunction = defaultCurve
            animationGroup.isRemovedOnCompletion = false
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            // 波纹内圈倍数
            scaleAnimation.fromValue = 1.1
            // 波纹外圈倍数
            scaleAnimation.toValue = 1.4
            // 渐变动画（values和keyTimes一一对应）
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnimation.values = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0]
            opacityAnimation.keyTimes = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
            animationGroup.animations = [scaleAnimation, opacityAnimation]
            pulsingLayer.add(animationGroup, forKey: "pulsing")
            animationLayer.addSublayer(pulsingLayer)
        }
        layer.addSublayer(animationLayer)
    }
}
*/

