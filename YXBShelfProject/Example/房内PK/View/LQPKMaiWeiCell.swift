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
        
        self.maiWeiView.titleLabel.text = "暂无用户"
        self.maiWeiView.userView.iconButton.setImage(UIImage(named: "CUYuYinFang_zhibojian_kongxian"), for: .normal)
        self.maiWeiView.charmButton.setImage(UIImage(named: "lq_pk_war"), for: .normal)
        self.maiWeiView.charmButton.backgroundColor = UIColor(hex: 0x161616, transparency: 0.2)
        
        if let mai = model.mai {
            let sort = adjustSortText(mai: mai);
            self.maiWeiView.sortLabel.text = sort.text
            if let isRed = sort.isRed {
                self.maiWeiView.sortLabel.backgroundColor = isRed ? UIColor(hex: 0xFF4E73) : UIColor(hex: 0x4ECAFF)
            }
        }
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
