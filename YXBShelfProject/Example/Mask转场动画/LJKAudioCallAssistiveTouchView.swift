//
//  LJKAudioCallAssistiveTouchView.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/21.
//

import UIKit

protocol LJKAudioCallAssistiveTouchViewDelegate: AnyObject {
    func assistiveTouchViewClicked()
    func closeClicked()
}


class LJKAudioCallAssistiveTouchView: UIView {
    
    private let defaultHeight: CGFloat = 55
    private let defaultWidth: CGFloat = 130
    private let leftAndRightSpace: CGFloat = 10
    private let kScreenWidth: CGFloat = ScreenConst.width
    private let kScreenHeight: CGFloat = ScreenConst.height
    private let iPhoneTopMargin: CGFloat = ScreenConst.statusBarHeight
    private let iPhoneBottomMargin: CGFloat = ScreenConst.bottomSpaceHeight
    private var halfWidth: CGFloat { self.frame.width / 2 }
    private var halfHeight: CGFloat { self.frame.height / 2 }
    
    
    weak var delegate: LJKAudioCallAssistiveTouchViewDelegate?
    
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        
        self.frame = CGRect(x: kScreenWidth - leftAndRightSpace - defaultWidth, y: kScreenHeight - 190, width: defaultWidth, height: defaultHeight)
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: defaultWidth, height: defaultHeight))
        backView.backgroundColor = .systemPink
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = defaultHeight / 2
        self.addSubview(backView)
        
        imageView = UIImageView(frame: CGRect(x: 8, y: 10, width: 35, height: 35))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35 / 2
        imageView.image = UIImage(named: "CUYuYinFang_login_logo")
        backView.addSubview(imageView)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 4
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        nameLabel = UILabel(frame: CGRect(x: 50, y: 11, width: 40, height: 14))
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.text = ""
        backView.addSubview(nameLabel)
        
        timeLabel = UILabel(frame: CGRect(x: 50, y: 32, width: 50, height: 12))
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = .white
        timeLabel.text = "回到房间"
        backView.addSubview(timeLabel)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(locationChange(_:)))
        panGestureRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(click(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 100 - 5, y: 12, width: 30, height: 30)
        closeButton.setImage(UIImage(named: "CUYuYinFang_zhibojian_guanbi"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        self.addSubview(closeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeBtnClick() {
        delegate?.closeClicked()
    }
    
    @objc func locationChange(_ gestureRecognizer: UIPanGestureRecognizer) {
        let panPoint = gestureRecognizer.location(in: UIApplication.shared.currentUIWindow())
        
        if gestureRecognizer.state == .changed {
            self.center = panPoint
        } else if gestureRecognizer.state == .ended {
            let iPhoneTopMargin = iPhoneTopMargin
            let iPhoneBottomMargin = iPhoneBottomMargin
            
            if panPoint.x <= kScreenWidth / 2 {
                if panPoint.y < iPhoneTopMargin + halfHeight {
                    UIView.animate(withDuration: 0.2) {
                        self.center = CGPoint(x: self.halfWidth + self.leftAndRightSpace, y: iPhoneTopMargin + self.halfHeight)
                    }
                } else if panPoint.y >= kScreenHeight - halfHeight - iPhoneBottomMargin {
                    UIView.animate(withDuration: 0.2) {
                        self.center = CGPoint(x: self.halfWidth + self.leftAndRightSpace, y: self.kScreenHeight - self.halfHeight - iPhoneBottomMargin)
                    }
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.center = CGPoint(x: self.halfWidth + self.leftAndRightSpace, y: panPoint.y)
                    }
                }
            } else if panPoint.x > kScreenWidth / 2 {
                if panPoint.y <= iPhoneTopMargin + halfHeight {
                    UIView.animate(withDuration: 0.2) {
                        self.center = CGPoint(x: self.kScreenWidth - self.halfWidth - self.leftAndRightSpace, y: iPhoneTopMargin + self.halfHeight)
                    }
                } else if panPoint.y > kScreenHeight - halfHeight - iPhoneBottomMargin {
                    UIView.animate(withDuration: 0.2) {
                        self.center = CGPoint(x: self.kScreenWidth - self.halfWidth - self.leftAndRightSpace, y: self.kScreenHeight - self.halfHeight - iPhoneBottomMargin)
                    }
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.center = CGPoint(x: self.kScreenWidth - self.halfWidth - self.leftAndRightSpace, y: panPoint.y)
                    }
                }
            }
        }
    }
    
    @objc func click(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.assistiveTouchViewClicked()
    }
}
