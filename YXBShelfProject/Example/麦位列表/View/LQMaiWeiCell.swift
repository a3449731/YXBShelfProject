//
//  LQMaiWeiCell.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class LQMaiWeiCell: UICollectionViewCell {
    
    weak var delegate: LQMaiWeiCellDelegate?
    
    // 定义一个DisposeBag用于管理订阅的生命周期
    private var disposed = DisposeBag()
    // 持有数据
    var model: LQMaiWeiModel?
    
    lazy var maiWeiView: LQMaiWeiView = {
        let view = LQMaiWeiView()
        view.delegate = self
        return view
    }()
    
    // OC写的展示表情类，只播放一次
    lazy var emotionView: LQRoomMaiWeiEmotionView = {
        let view = LQRoomMaiWeiEmotionView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    private func creatUI() {
        self.contentView.addSubviews([maiWeiView, emotionView])
        maiWeiView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(60.fitScale())
            make.height.equalTo(100.fitScale())
        }
        
        emotionView.snp.makeConstraints { make in
            make.edges.equalTo(maiWeiView.userView)
        }
    }
    
    // 配置数据
    func setup(model: LQMaiWeiModel) {
        self.model = model
        
        // 这个主持的标志只在主持麦上才有可能展示
        self.maiWeiView.identityImageView.isHidden = true
        // 存在用户id的时候
        if let userId = model.id,
           userId.isEmpty == false {
            // 如果是主持麦麦
            if model.mai == .host {
                self.maiWeiView.sortLabel.isHidden = true
                // 五人房也不需要这个标志
                if model.roomType == .merchant_5 {
                    self.maiWeiView.identityImageView.isHidden = true
                } else {
                    self.maiWeiView.identityImageView.isHidden = false
                }
                self.maiWeiView.identityImageView.image = UIImage(named: "CUYuYinFang_fanzhuHead")
            } else {
                self.maiWeiView.sortLabel.isHidden = false
            }
            self.maiWeiView.sortLabel.text = model.mai?.rawValue
            if model.isex == .male {
                self.maiWeiView.sortLabel.backgroundColor = UIColor(hex: 0x4ECAFF)
            } else {
                self.maiWeiView.sortLabel.backgroundColor = UIColor(hex: 0xFF4E73)
            }
            self.maiWeiView.titleLabel.text = model.uname?.truncated(toLength: 6)
            self.maiWeiView.charmButton.isHidden = false
            self.maiWeiView.charmButton.setTitle(formatNumberString(model.meiNum), for: .normal)
            self.maiWeiView.userView.headerView.isHidden = false
            self.maiWeiView.userView.headerView.setImage(url: model.uimg, headerFrameUrl: model.headKuang, placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
        } else {
            self.maiWeiView.sortLabel.isHidden = true
            self.maiWeiView.charmButton.isHidden = true
            self.maiWeiView.userView.headerView.isHidden = true
            if model.roomType == .merchant_5 {
                // 如果是5人房
                self.maiWeiView.titleLabel.text = model.mai?.titleName_5
            } else if let customName = model.name {
                // 如果自定义过麦位名
                self.maiWeiView.titleLabel.text = customName
            } else if model.mai == .boss {
                self.maiWeiView.titleLabel.text = "老板位"
            } else if model.mai == .host {
                self.maiWeiView.titleLabel.text = "主持位"
            } else {
                self.maiWeiView.titleLabel.text = "\(model.mai?.rawValue ?? "")号麦"
            }
        }
        
        // icon图的区别，5人房与9人房
        if model.roomType == .merchant_5 {
            self.maiWeiView.userView.iconButton.setImage(UIImage(named: model.mai?.iconImageName_5 ?? ""), for: .normal)
        } else {
            let image = self.iconMatch(isLock: model.isMaiWeiLock, isMute: model.isMaiWeiMute, mai: model.mai)
            self.maiWeiView.userView.iconButton.setImage(image, for: .normal)
        }
        
        
        // 下面都是可能因为收到了某些消息，需要变化界面的绑定
                
        // 这个用户发送了表情
        model.rx.observeWeakly(String.self, "emotionUrl")
//            .debug("\(model.mai?.rawValue ?? "")号麦 发送了表情")
            .subscribe(onNext: { [weak self] emotionUrl in
                // 如果麦上有人
                if let uid = model.id, uid.isEmpty == false, let url = emotionUrl, url.isEmpty == false {
                    self?.emotionView.roomEmotionUrl = url
                    model.emotionUrl = nil
                }
            })
            .disposed(by: disposed)
        
        // 收到了魅力值变化的消息
        model.rx.observeWeakly(String.self, "meiNum")
//            .debug("\(model.mai?.rawValue ?? "")号麦 魅力值变化了吗")
            .subscribe(onNext: { [weak self] charm in
                // 如果麦上有人
                if let uid = model.id, uid.isEmpty == false {
                    self?.maiWeiView.charmButton.setTitle(self?.formatNumberString(charm), for: .normal)
                }
            })
            .disposed(by: disposed)
        
        // 是否正在说话绑定脉波
        model.rx.observeWeakly(Bool.self, "isSpeaking")
//            .debug("\(model.mai?.rawValue ?? "")号麦 有人正在说话吗 \(self)")
            .subscribe(onNext: { [weak self] isMuted in
                // 麦波webp
                if let isMuted = isMuted,
                   isMuted == true,
                   let uid = model.id,
                    uid.isEmpty == false,
                   let url = Bundle.main.url(forResource: "micWave", withExtension: "webp") {
                    self?.maiWeiView.userView.rippleView.sd_setImage(with: url)
                } else {
                    self?.maiWeiView.userView.rippleView.image = nil
                }
            })
            .disposed(by: disposed)
        
        // 是否闭麦绑定到喇叭
        model.rx.observeWeakly(Bool.self, "isb")
//            .debug("\(model.mai?.rawValue ?? "")号麦 开麦了吗")
            .subscribe(onNext: { [weak self] isMuted in
                if let isMuted = isMuted {
                    self?.maiWeiView.userView.voiceImageView.isHidden = !isMuted
                    // 如果闭麦了，麦波也要去改变，推流结束不会再出发回调，所以这调整一道的话，为了保险
                    if isMuted {
                        model.isSpeaking = false
                    }
                } else {
                    self?.maiWeiView.userView.voiceImageView.isHidden = true
                }
            })
            .disposed(by: disposed)

        // 有一些监听5人是不需要的，他没有
        if model.roomType == .merchant_5 {
            
        } else {
            // 收到了修改麦位名的消息
            model.rx.observeWeakly(String.self, "name")
//                .debug("\(model.mai ?? "")号麦 修改麦位名称吗")
                .subscribe(onNext: { [weak self] name in
                    // 如果上麦位上有人，就不动
                    if let uid = model.id, uid.isEmpty == false {
                        
                    } else {
                        if let name = name,
                           name.isEmpty == false {
                            // 麦位上没人，修改麦位名
                            self?.maiWeiView.titleLabel.text = name
                        }
                    }
                })
                .disposed(by: disposed)
            
            // 麦位是否被禁言
            model.rx.observeWeakly(Bool.self, "isMaiWeiMute")
//                .debug("\(model.mai ?? "")号麦 是否被禁言 \(self)")
                .subscribe(onNext: { [weak self] isMuted in
                    let image = self?.iconMatch(isLock: model.isMaiWeiLock, isMute: isMuted, mai: model.mai)
                    self?.maiWeiView.userView.iconButton.setImage(image, for: .normal)
                })
                .disposed(by: disposed)
            
            // 麦位是否被关闭
            model.rx.observeWeakly(Bool.self, "isMaiWeiLock")
//                .debug("\(model.mai ?? "")号麦 是否被关闭 \(self)")
                .subscribe(onNext: { [weak self] isLock in
                    let image = self?.iconMatch(isLock: isLock, isMute: model.isMaiWeiMute, mai: model.mai)
                    self?.maiWeiView.userView.iconButton.setImage(image, for: .normal)
                })
                .disposed(by: disposed)
        }
    }
    
    // 匹配麦位站位图片状态，
    private func iconMatch(isLock: Bool? = false, isMute: Bool? = false, mai: MaiWeiIndex?) -> UIImage? {
        // 老板位
        if mai == .boss {
            return UIImage(named: "CUYuYinFang_zhibojian_Boss")
        }
        
        if isLock! {
            return UIImage(named: "CUYuYinFang_zhibojian_shangsuo")
        } else if isMute! {
            return UIImage(named: "CUYuYinFang_zhibojian_bimai")
        } else {
            return UIImage(named: "CUYuYinFang_zhibojian_kongxian")
        }
    }
    
    private func formatNumberString(_ numberString: String?) -> String {
        guard let numberString = numberString else {
            return "0"
        }
        
        guard let number = Double(numberString) else {
            return "0"
        }
        
        if number > 10000 {
            let formattedNumber = String(format: "%.1fw", number / 10000)
            return formattedNumber
        } else {
            return numberString
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // RxSwift在UITableViewCell或者UICollectionViewCell中绑定数据遇到的UI混乱的问题 https://www.cnblogs.com/supersr/p/15693611.html
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposed = DisposeBag()
    }
}

// MARK: - LQMaiWeiViewDelegate 代理
extension LQMaiWeiCell: LQMaiWeiViewDelegate {
    
    // 点击了麦位的icon。
    func maiWeiView(view: LQMaiWeiView, didTapMaiWeiIcon: LQMaiWeiModel?) {
        if let model = self.model {
            self.delegate?.maiWeiCell?(didTapMaiWeiIcon: self, model: model)
        } else {
            debugPrint("麦位模型数据错误")
        }
    }
    
    // 麦上有用户，点击的是userheader。
    func maiWeiView(view: LQMaiWeiView, didTapUserHeader: LQMaiWeiModel?) {
        if let model = self.model {
            self.delegate?.maiWeiCell?(didTapUserHeader: self, model: model)
        } else {
            debugPrint("麦位模型数据错误")
        }
    }
    
    // 麦上有用户，点击的是魅力值。
    func maiWeiView(view: LQMaiWeiView, didTapCharmView: LQMaiWeiModel?) {
        if let model = self.model {
            self.delegate?.maiWeiCell?(didTapCharmView: self, model: model)
        } else {
            debugPrint("麦位模型数据错误")
        }
    }

}


