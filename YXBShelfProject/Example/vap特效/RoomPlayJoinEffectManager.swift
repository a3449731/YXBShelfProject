//
//  RoomPlayJoinEffectManager.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/20.
//

import UIKit

protocol RoomPlayJoinEffectManagerDelegate: AnyObject {
    func playVap(_ view: PlayVapView, didStart container: UIView, url urlString: String)
    func playVap(_ view: PlayVapView, didStop container: UIView, url urlString: String)
    func playVap(_ view: PlayVapView, didFail error: Error, url urlString: String)
}

// MARK: - 连续播放数队列管理
/// 播放队列管理， 连播的时候一定要注意。vap内部判断了容器是否展示在容器上，如果容器没有展示就播放不出来。所以在连播中间最好给一个间隔时间。
class RoomPlayJoinEffectManager: NSObject {
 
    weak var delegate: RoomPlayJoinEffectManagerDelegate?
    
    var animationArray: [[String: String]] = [[:]]
    var isPlayingAnimation = false
    var isPaused = false
    var playView: PlayVapView!
    // 记录正在播放的是哪个url，播完好移除
    private var isPlayingDic: [String: String]?
    private let lock = NSLock()
    
    init(superView: UIView) {
        super.init()
        animationArray = []
        lock.name = "com.example.animationLock"
        isPlayingAnimation = false
        isPaused = false
        
        playView = PlayVapView()
        playView.backgroundColor = .clear
        playView.delegate = self
        playView.isHidden = true
        superView.addSubview(playView)
        
        playView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addAnimation(_ dic: [String: String]) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        animationArray.append(dic)
    }
    
    func addAnimations(_ dicArray: [[String: String]]) {
        lock.lock()
        defer {
            lock.unlock()
        }
        animationArray.append(contentsOf: dicArray)
    }
    
    func removeAnimation(_ dic: [String: String]) {
        if dic == isPlayingDic {
            stopCurrentAnimation()
        } else {
            lock.lock()
            defer {
                lock.unlock()
            }
            if let index = animationArray.firstIndex(of: dic) {
                debugPrint("YXB_LOG: 移除指定动画, \(index)")
                animationArray.remove(at: index)
            }
        }
    }
    
    func stopCurrentAnimation() {
        lock.lock()
        defer {
            lock.unlock()
        }
        if let index = animationArray.firstIndex(of: isPlayingDic!) {
            debugPrint("YXB_LOG: 停止当前动画, \(index)")
            animationArray.remove(at: index)
        }
    }
    
    func playAnimations() {
        if animationArray.isEmpty || isPlayingAnimation || isPaused {
            debugPrint("YXB_LOG: 现在正在一个特殊的状态, 排队等播出, \(animationArray), 播放状态:\(isPlayingAnimation), 暂停状态:\(isPaused)")
            return
        }
        
        isPlayingAnimation = true
        let dic = animationArray[0]
        isPlayingDic = dic
        if let passAction = dic["passAction"] {
            playView.startVap(urlString: passAction, userInfo: dic)
        }
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        if isPaused {
            isPaused = false
            playAnimations()
        }
    }
    
    func next() {
        debugPrint("YXB_LOG: 播放下一个动画, 注意啊，在连播时候一定要给个延迟调用")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.playAnimations()
        }
    }
    
    func stopAndClear() {
        lock.lock()
        defer {
            lock.unlock()
        }
        animationArray.removeAll()
        playView.stopVap()
    }
    
    
}

// MARK: - PlayVapViewViewDelegate
extension RoomPlayJoinEffectManager: PlayVapViewViewDelegate {
    func effects(startAnimation: PlayVapView, container: UIView) {
        playView.isHidden = false
        
        // 默认实现，如果外界实现了代理，就不会走这个了
        if let urlString = isPlayingDic?["headerUrl"] as? String {
            delegate?.playVap(startAnimation, didStart: container, url: urlString)
            return
        }
    }
    
    func effects(stopAnimation: PlayVapView, container: UIView) {
        playView.isHidden = true
        removeAnimation(isPlayingDic!)
        isPlayingAnimation = false
        isPlayingDic = nil
        
        // 默认实现，如果外界实现了代理，就不会走这个了
        if let urlString = isPlayingDic?["headerUrl"] as? String {
            delegate?.playVap(stopAnimation, didStop: container, url: urlString)
            return
        }
        
        next()
    }
    
    func effects(didFail: PlayVapView, error: Error) {
        playView.isHidden = true
        removeAnimation(isPlayingDic!)
        isPlayingAnimation = false
        isPlayingDic = nil
        
        // 默认实现，如果外界实现了代理，就不会走这个了
        if let urlString = isPlayingDic?["headerUrl"] as? String {
            delegate?.playVap(didFail, didFail: error, url: urlString)
            return
        }
        
        next()
    }
}
