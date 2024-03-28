//
//  GXWCalendarCell.swift
//  YXBShelfProject
//
//  Created by yang on 2024/3/24.
//

import UIKit
import FSCalendar

class GXWCalendarCell: FSCalendarCell {
    /*
     *  @brief 是否选中了这一天。
     */
    var hasSelect: Bool = false {
        didSet {
            self.selectView.isHidden = !hasSelect
            if hasSelect {
                self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                self.titleLabel.font = UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    private var selectView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 243/255, green: 53/255, blue: 45/255, alpha: 1)
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectView)
        selectView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let centerX = bounds.size.width / 2
        let width: CGFloat = 20
        let y = titleLabel.frame.origin.y + titleLabel.frame.size.height
        selectView.frame = CGRect(x: centerX - width / 2, y: y - 3, width: width, height: 3)
    }
    
    // 在父类一些属性调整时会触发，如需要做对应的特殊设置可以在这里完成。
    override func configureAppearance() {
        super.configureAppearance()
        // 重新更新占位的颜色
        if isPlaceholder {
            titleLabel.textColor = calendar.appearance.titlePlaceholderColor
        }
    }
}
