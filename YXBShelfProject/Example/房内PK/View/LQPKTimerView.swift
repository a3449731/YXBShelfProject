//
//  LQPKTimerView.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/12/7.
//

import UIKit

class LQPKTimerView: UIView {
    // 开播时间,开播了多少秒,由外界传入
    var premiereSecond: Int = 0 {
        didSet {
            if GCDTimerManager.shared.hasTimer(timerName: kPKTimeCaculate) {
                GCDTimerManager.shared.invalidateTimer(timerName: kPKTimeCaculate)
            }
            caculateSecond = premiereSecond
            // 开启定时器
            GCDTimerManager.shared.scheduleDispatchTimer(timerName: kPKTimeCaculate, timeInterval: 1, repeats: true) { [weak self] in
                self?.updateUI()
            }
        }
    }
    
    private var caculateSecond: Int = 0
        
    private let kPKTimeCaculate = "kPKTimeCaculate"
    
    // 背景
    private let bgImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(name: "lq_pk_time", placeholderImage: nil)
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = MyUIFactory.commonLabel(text: "PK暂未开始", textColor: .titleColor_white, font: .titleFont_10, textAlignment: .center)
        return label;
    }()
        
    // 格式化
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    private func creatUI() {
        addSubviews([bgImageView, timeLabel])
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
//    "premiereSecond" : 445613, 代表秒数
    // 更新UI,通过定时器触发
    private func updateUI() {
        caculateSecond -= 1
        if caculateSecond < 1 {
            GCDTimerManager.shared.invalidateTimer(timerName: kPKTimeCaculate)
        }
//        debugPrint("我看看怎么在调用")
        let timeInterval = TimeInterval(caculateSecond)
        
        if let formattedString = formatter.string(from: timeInterval) {
            timeLabel.text = "PK\(formattedString)"
        }
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
        // 销毁定时器
        GCDTimerManager.shared.invalidateTimer(timerName: kPKTimeCaculate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    let firstView = LQPKTimerView()
    firstView.frame = CGRectMake(150, 150, 80.fitScale(), 20.fitScale())
    firstView.premiereSecond = 10
    
    contentView.addSubview(firstView)
    
    return contentView
}
