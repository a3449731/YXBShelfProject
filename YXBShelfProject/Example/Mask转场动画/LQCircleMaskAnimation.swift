//
//  LQCircleMaskAnimation.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/21.
//

import UIKit

class LQCircleMaskAnimation: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    private let animateDuration = 0.28
    
    var context: UIViewControllerContextTransitioning?
    
    // 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 这是为了禁用UITabBar的隐式动画
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // 在动画结束时调用 [CATransaction commit]
        
        // 得到上下文
        self.context = transitionContext
        // 获取容器视图
        let container = transitionContext.containerView
        // 获取参与转场的viewcontroller
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        if toVC is MaskViewController {
            container.addSubview(toVC!.view)
            addBecomeBigAnimation(toVCView: toVC!.view)
        } else if fromVC is MaskViewController {
            container.addSubview(toVC!.view)
            container.addSubview(fromVC!.view)
            addBecomeSmallAnimation(toVCView: fromVC!.view)
        }
        
        // 隐藏导航栏，避免在动画中不协调
        let shouldHideBottomBar = toVC is MaskViewController
        if shouldHideBottomBar {
            fromVC?.tabBarController?.tabBar.isHidden = true
        }        
    }
    
    func addBecomeSmallAnimation(toVCView: UIView) {
        let endFrame = CGRect(x: 150, y: 150, width: 150, height: 50)
        // 进行坐标系转换
        debugPrint("结束坐标：\(endFrame)")
        
        // 用对角线做圆的半径。勾股定理
        let width = (UIScreen.main.bounds.width - endFrame.size.width / 2)
        let height = (UIScreen.main.bounds.height - endFrame.size.height / 2)
        let radius = sqrt(pow(width, 2) + pow(height, 2))
        let startFrame = endFrame.insetBy(dx: -radius, dy: -radius)
        debugPrint("起始坐标：\(startFrame)")
        
        // 创建动画
        let maskLayerAnimation = creatMaskAnimation(keyPath: "path", startFrame: startFrame, endFrame: endFrame, duration: animateDuration)
        maskLayerAnimation.delegate = self
        
        // 添加动画遮罩
        let shapeLayer = CAShapeLayer()
        shapeLayer.add(maskLayerAnimation, forKey: "path")
        toVCView.layer.mask = shapeLayer
    }
    
    func addBecomeBigAnimation(toVCView: UIView) {
        let startFrame = CGRect(x: 235, y: 622, width: 130, height: 55)
        // 进行坐标系转换
        debugPrint("起始坐标：\(startFrame)")
        
        // 用屏幕对角线做圆的半径。勾股定理
        let width = (UIScreen.main.bounds.width - startFrame.size.width / 2)
        let height = (UIScreen.main.bounds.height - startFrame.size.height / 2)
        let radius = sqrt(pow(width, 2) + pow(height, 2))
        let endFrame = startFrame.insetBy(dx: -radius, dy: -radius)
        debugPrint("结束坐标：\(endFrame)")
        
        // 创建动画
        let maskLayerAnimation = creatMaskAnimation(keyPath: "path", startFrame: startFrame, endFrame: endFrame, duration: animateDuration)
        maskLayerAnimation.delegate = self
        
        // 添加动画遮罩
        let shapeLayer = CAShapeLayer()
        shapeLayer.add(maskLayerAnimation, forKey: "path")
        toVCView.layer.mask = shapeLayer
    }
    
    func creatMaskAnimation(keyPath: String, startFrame: CGRect, endFrame: CGRect, duration: CFTimeInterval) -> CABasicAnimation {
        // 起始圆
        let startPath = UIBezierPath(roundedRect: startFrame, cornerRadius: startFrame.size.width / 2)
        // 终止圆
        let endPath = UIBezierPath(roundedRect: endFrame, cornerRadius: endFrame.size.width / 2)
        let maskLayerAnimation = CABasicAnimation(keyPath: keyPath)
        maskLayerAnimation.fromValue = startPath.cgPath
        maskLayerAnimation.toValue = endPath.cgPath
        maskLayerAnimation.duration = duration
        // 动画结束停留在最后一帧
        maskLayerAnimation.fillMode = .forwards
        maskLayerAnimation.isRemovedOnCompletion = false
        
        return maskLayerAnimation
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.context?.viewController(forKey: .to)?.view.layer.mask = nil
        self.context?.viewController(forKey: .from)?.view.layer.mask = nil
        self.context?.completeTransition(!(self.context?.transitionWasCancelled ?? true))
        
        CATransaction.commit()
    }
}
