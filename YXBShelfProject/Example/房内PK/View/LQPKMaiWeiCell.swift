//
//
//  LQPKMaiWeiCell.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/7.
//

import UIKit

class LQPKMaiWeiCell: LQMaiWeiCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // 在麦位LQMaiWeiCell上对展示的样式做一点小调整
    override func setup(model: LQMaiWeiModel) {
        super.setup(model: model)
        
        // pk中不需要这个标识
        self.maiWeiView.userView.tipLabel.isHidden = true;
        
        if let userId = model.id,
           userId.isEmpty == false {
            self.maiWeiView.titleLabel.text = model.uname?.truncated(toLength: 6)
        } else {
            if model.mai == .host {
                self.maiWeiView.titleLabel.text = "主持位"
            } else {
                self.maiWeiView.titleLabel.text = "暂无用户"
            }
        }
        let image = self.iconMatch(isLock: model.isMaiWeiLock, isMute: model.isMaiWeiMute, model: model)
        self.maiWeiView.userView.iconButton.setImage(image, for: .normal)
        self.maiWeiView.charmButton.setImage(UIImage(named: "lq_pk_war"), for: .normal)
        self.maiWeiView.charmButton.backgroundColor = UIColor(hex: 0x161616, transparency: 0.2)
        
        if let mai = model.mai {
            let sort = adjustSortText(mai: mai);
            self.maiWeiView.sortLabel.text = sort.text
            if let isRed = sort.isRed {
                self.maiWeiView.sortLabel.backgroundColor = isRed ? UIColor(hex: 0xFF4E73) : UIColor(hex: 0x4ECAFF)
            }
        }
        if let pkType = model.pkType, pkType != "1" {
            self.maiWeiView.charmButton.setTitle(model.combatValue?.formatNumberString(), for: .normal)
        }
        
        
        // 收到了魅力值变化的消息
        model.rx.observeWeakly(String.self, "combatValue")
//            .debug("\(model.mai?.rawValue ?? "")号麦 战力值变化了吗")
            .subscribe(onNext: { [weak self] combatValue in
                // 如果麦上有人
                if let uid = model.id, uid.isEmpty == false,
                   let pkType = model.pkType, pkType != "1" {
                    self?.maiWeiView.charmButton.setTitle(model.combatValue?.formatNumberString(), for: .normal)
                }
            })
            .disposed(by: disposed)
    }
    
    // 调整序号，红方1,2,3，4   蓝方1,2,3,4
    private typealias SortAlias = (isRed: Bool?, text: String?)
    private func adjustSortText(mai: MaiWeiIndex) -> SortAlias {
        var sort = SortAlias(nil, nil)
        switch mai {
        case .one, .two, .five, .six:
            sort.isRed = true
            sort.text = mai.pkSort
        case .three, .four, .seven, .boss:
            sort.isRed = false
            sort.text = mai.pkSort
        default:
            break
        }
        return sort
    }
    
    // 重写了父类的方法
    override func iconMatch(isLock: Bool? = false, isMute: Bool? = false, model: LQMaiWeiModel) -> UIImage? {
        if isLock! {
            return UIImage(named: "CUYuYinFang_zhibojian_shangsuo")
        } else if isMute! {
            return UIImage(named: "CUYuYinFang_zhibojian_bimai")
        } else {
            return UIImage(named: "CUYuYinFang_zhibojian_kongxian")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
