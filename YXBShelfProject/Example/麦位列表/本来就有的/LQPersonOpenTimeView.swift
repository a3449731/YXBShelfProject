//
//  LQPersonOpenTime.swift
//  CUYuYinFang
//
//  Created by yangxiaobin on 2023/11/14.
//  Copyright © 2023 lixinkeji. All rights reserved.
//

import UIKit

/// 个人房 开播时长记时间
@objc class LQPersonOpenTimeView: UIView {
    // 开播时间,开播了多少秒,由外界传入
    @objc var premiereSecond: Int = 0 {
        didSet {
            if GCDTimerManager.shared.hasTimer(timerName: kOpenTimeCaculate) {
                GCDTimerManager.shared.invalidateTimer(timerName: kOpenTimeCaculate)
            }
            caculateSecond = premiereSecond
            // 开启定时器
            GCDTimerManager.shared.scheduleDispatchTimer(timerName: kOpenTimeCaculate, timeInterval: 1, repeats: true) { [weak self] in
                self?.updateUI()
            }
        }
    }
    
    var caculateSecond: Int = 0
    
    
    @objc let kOpenTimeCaculate = "kOpenTimeCaculate"
    
    let timeLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: nil, textColor: .titleColor_white, font: .titleFont_9, textAlignment: .left)
        return label;
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    private func creatUI() {
        addSubview(timeLabel)
        
        let pointView = UIView()
        pointView.layerCornerRadius = 1
        pointView.backgroundColor = UIColor(hex: 0x47F3CD)
        addSubview(pointView)
        
        pointView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(1)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(2)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            // 为了撑起外部view
            make.right.equalToSuperview();
        }
    }
    
//    "premiereSecond" : 445613, 代表秒数
    // 更新UI,通过定时器触发
    private func updateUI() {
        caculateSecond += 1
//        debugPrint("我看看怎么在调用")
        let timeInterval = TimeInterval(caculateSecond)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad

        if let formattedString = formatter.string(from: timeInterval) {
            timeLabel.text = formattedString
        }
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
        // 销毁定时器
        GCDTimerManager.shared.invalidateTimer(timerName: kOpenTimeCaculate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
