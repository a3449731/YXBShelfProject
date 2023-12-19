//
//  LQAnimationProtocol.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/22.
//

// 抽离的协议，Swift协议。遵守了此协议的对象，就可以使用LQAnimationQueue队列来播放动画
import UIKit

protocol LQPlayableAnimation {
    var delegate: LQAnimationDelegate? { get set }
    func start(model: LQAnimationModel)
    func stop(model: LQAnimationModel)
}

// 动画的状态过程回调，类似OC协议
protocol LQAnimationDelegate: AnyObject {
    func animationDidStart(_ animation: LQAnimationModel)
    func animationDidStop(_ animation: LQAnimationModel)
    func animationDidFail(_ animation: LQAnimationModel, with error: Error)
}


// MARK:  飘屏动画的动画逻辑
protocol LQFloatAnimation {
    
}

// 分配动画时间
private struct Time {
    // 其实时间
    fileprivate static let startTime: CFTimeInterval = 0.000001
    /// 进入的时间
    fileprivate static let join: CFTimeInterval = 2
    /// 停留的时间
    fileprivate static let stay: CFTimeInterval = 4
    // 离开的起始时间
    fileprivate static var levelStart: CFTimeInterval = {
        join + stay
    }()
    /// 离开的时间
    fileprivate static let level: CFTimeInterval = 2
    // 总时间
    fileprivate static var total: CFTimeInterval = {
        join + level + stay
    }()
}

extension LQFloatAnimation {

    func createAnimation(for view: UIView) -> CAAnimation {
        let groupAnimationAnimation = CAAnimationGroup()
        groupAnimationAnimation.beginTime = view.layer.convertTime(CACurrentMediaTime(), from: nil) + Time.startTime
        groupAnimationAnimation.duration = Time.total
        groupAnimationAnimation.fillMode = .forwards
        groupAnimationAnimation.isRemovedOnCompletion = false
        groupAnimationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        // Group Animation Animations
        // transform.translation.x
        let transformTranslationXAnimation = CABasicAnimation()
        transformTranslationXAnimation.beginTime = Time.startTime
        transformTranslationXAnimation.duration = Time.join
        transformTranslationXAnimation.fillMode = .forwards
        transformTranslationXAnimation.isRemovedOnCompletion = false
        transformTranslationXAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transformTranslationXAnimation.keyPath = "transform.translation.x"
        transformTranslationXAnimation.toValue = 0
        //        transformTranslationXAnimation.fromValue = _window_width - 86 - 14
        transformTranslationXAnimation.fromValue = ScreenConst.width
        
        // transform.translation.x
        let transformTranslationXAnimation1 = CABasicAnimation()
        transformTranslationXAnimation1.beginTime = Time.levelStart
        transformTranslationXAnimation1.duration = Time.level
        transformTranslationXAnimation1.fillMode = .forwards
        transformTranslationXAnimation1.isRemovedOnCompletion = false
        transformTranslationXAnimation1.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transformTranslationXAnimation1.keyPath = "transform.translation.x"
        transformTranslationXAnimation1.toValue = -ScreenConst.width
        transformTranslationXAnimation1.fromValue = 0
        groupAnimationAnimation.animations = [ transformTranslationXAnimation, transformTranslationXAnimation1 ]
        
        return groupAnimationAnimation
    }
}

