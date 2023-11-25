//
//  LQMaiWeiCell.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class LQMaiWeiCell: UICollectionViewCell {
    
    // 定义一个DisposeBag用于管理订阅的生命周期
    private let disposed = DisposeBag()
    // 持有数据
    var model: LQMaiWeiModel?
    
    let maiWeiView: LQMaiWeiView = {
        let view = LQMaiWeiView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    private func creatUI() {
        self.contentView.addSubview(maiWeiView)
        maiWeiView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(60.fitScale())
            make.height.equalTo(100.fitScale())
        }
    }
    
    // 配置数据
    func setup(model: LQMaiWeiModel) {
        self.model = model
        
        // 这个主持的标志只在主持麦上才有可能展示
        self.maiWeiView.identityImageView.isHidden = true
        // 存在用户id的时候
        if let userId = model.id {
            self.maiWeiView.sortLabel.isHidden = false
            self.maiWeiView.sortLabel.text = model.mai
            self.maiWeiView.titleLabel.text = model.uname
            self.maiWeiView.charmButton.isHidden = false
            self.maiWeiView.charmButton.setTitle(model.meiNum, for: .normal)
            self.maiWeiView.userView.headerView.setImage(url: model.uimg, headerFrameUrl: model.headKuang, placeholderImage: nil)
        } else {
            self.maiWeiView.sortLabel.isHidden = true
            self.maiWeiView.charmButton.isHidden = true
            self.maiWeiView.titleLabel.text = "\(model.mai ?? "")号麦"
        }
        
        
        // 是否闭麦绑定到喇叭
        model.rx.observe(Bool.self, "isSpeaking")
            .debug()
            .subscribe(onNext: { [weak self] isMuted in
                // 麦波webp
                if let isMuted = isMuted,
                   isMuted == true,
                   let url = Bundle.main.url(forResource: "micWave", withExtension: "webp") {
                    self?.maiWeiView.userView.rippleView.sd_setImage(with: url)
                } else {
                    self?.maiWeiView.userView.rippleView.image = nil
                }
            })
            .disposed(by: disposed)
        
        // 是否闭麦绑定到喇叭
        model.rx.observe(Bool.self, "isb")
            .debug()
            .subscribe(onNext: { [weak self] isMuted in
                if let isMuted = isMuted {
                    self?.maiWeiView.userView.voiceImageView.isHidden = !isMuted
                } else {
                    self?.maiWeiView.userView.voiceImageView.isHidden = true
                }
            })
            .disposed(by: disposed)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



