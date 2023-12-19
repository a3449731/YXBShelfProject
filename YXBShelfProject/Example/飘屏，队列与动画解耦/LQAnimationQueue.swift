//
//  LQAnimationQueue.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/22.
//

import UIKit


/// 动画队列: 使用队列播放动画示例
///
/// class ExampleAnimationView: LQPlayableAnimation {
///     weak var delegate: LQAnimationDelegate?
///
///     func start(model: LQAnimationModel) {
///         // 实现具体的动画开始逻辑
///         delegate?.animationDidStart(model)
///     }
///
///     func stop(model: LQAnimationModel) {
///         // 实现具体的动画停止逻辑
///         delegate?.animationDidStop(model)
///     }
///
///     // 其他动画相关的方法和属性
/// }
///
/// // 飘屏的管理队列
/// let floatAnimationQueue = LQAnimationQueue(playView: FloatingScreenView())
///
/// override func viewDidLoad() {
///     super.viewDidLoad()
///
///     var model = LQAnimationModel()
///     model.effectUrl = "http:xxxxxx"
///     floatAnimationQueue.addAnimation(model)
///
///     floatAnimationQueue.playAnimations()
/// }
class LQAnimationQueue<T: FloatingBaseView & LQPlayableAnimation> {

    // 数据模型数组
    private var animationArray: [LQAnimationModel] = []
    private var isPlayingAnimation = false
    private var isPaused = false
    private let lock = NSLock()
    
    // 为了方便拓展,需要一个泛型的播放动画的实体类
    var playView: T! {
        didSet {
            self.playView.delegate = self
        }
    }
    
    init() {}
    
    // 设计的失败。会有不同view进行动画
//    init(playView: T) {
//        self.playView = playView
//        self.playView.delegate = self
//    }
        
    // 添加动画
    func addAnimation(_ animation: LQAnimationModel) {
        lock.lock()
        defer { lock.unlock() }
        animationArray.append(animation)
    }
    
    // 添加多个动画
    func addAnimations(_ animations: [LQAnimationModel]) {
        lock.lock()
        defer { lock.unlock() }
        animationArray.append(contentsOf: animations)
    }
    
    // 移除动画
    func removeAnimation(_ animation: LQAnimationModel) {
        lock.lock()
        defer { lock.unlock() }
        if let index = animationArray.firstIndex(of: animation) {
            // 如果要移除的是第一个且正在进行播放的话，先不管他吧。等他自然播完进行自然移除
            if index == 0 && isPlayingAnimation {
                
            } else {
                animationArray.remove(at: index)
            }
        }
    }
    
    // 暂停
    func pause() {
        isPaused = true
    }
    
    // 恢复
    func resume() {
        if isPaused {
            isPaused = false
            playAnimations()
        }
    }
    
    // 播放动画
    func playAnimations() {
        guard let animation = animationArray.first else {
            debugPrint("数组空了，没有待播动画")
            return
        }
        
        if isPlayingAnimation {
            debugPrint("排队去，目前有动画正在播放")
            return
        }
        
        if isPaused {
            debugPrint("特殊状态，队列已被暂停")
            return
        }
        
        isPlayingAnimation = true
        // 真正的去执行动画
        debugPrint("开始动画")
        if self.playView != nil {
            self.playView.start(model: animation)
        }
    }
    
    // 下一个
    func next() {
        debugPrint("准备下一个动画")
        playAnimations()
    }
    
    // 停止并且清空数组
    func stopAndClear() {
        lock.lock()
        defer { lock.unlock() }
        debugPrint("清空数组")
        animationArray.removeAll()
    }
}

// MARK: LQAnimationDelegate
extension LQAnimationQueue: LQAnimationDelegate {
    func animationDidStart(_ animation: LQAnimationModel) {
        // 处理动画开始事件
        // 因为是加在window上的，所以选择有动画的时候添加，动画结束时移除。避免盖在上面有响应事件
        UIApplication.shared.getKeyWindow()?.addSubview(self.playView)
    }
    
    func animationDidStop(_ animation: LQAnimationModel) {
        // 处理动画停止事件
        isPlayingAnimation = false
        removeAnimation(animation)
        self.playView.removeFromSuperview()
        
        if !isPaused {
            playAnimations()
        }
    }
    
    func animationDidFail(_ animation: LQAnimationModel, with error: Error) {
        // 处理动画失败事件
        isPlayingAnimation = false
        removeAnimation(animation)
        self.playView.removeFromSuperview()
        
        if !isPaused {
            playAnimations()
        }
    }
}
