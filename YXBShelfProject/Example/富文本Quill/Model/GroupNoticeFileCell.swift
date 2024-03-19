//
//  GroupNoticeFileCell.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/2/7.
//

import UIKit

class GroupNoticeFileCell: UITableViewCell {
    
    var model: GroupNoticeFileModel?
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .titleColor
        label.font = .systemFont(ofSize: 14.0)//self.theme.fonts.caption2
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTitleColor
        label.font = .systemFont(ofSize: 12.0)//self.theme.fonts.caption2
        return label
    }()
    
    var deleteClosure: ((GroupNoticeFileModel?) -> Void)?
    lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "gn_list_ordered_light"), for: .normal)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.creatUI()
    }
    
    private func creatUI() {
        let bgView = UIView()
        bgView.backgroundColor = .backgroundColor_gray
        bgView.layer.cornerRadius = 6
        bgView.layer.masksToBounds = true
        contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(deleteButton)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(52)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top).offset(0)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-80)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-80)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
    }
    
    func setup(model: GroupNoticeFileModel) {
        self.model = model
        self.iconImageView.image = UIImage(named: "gn_list_ordered_light")
        self.titleLabel.text = model.file_name
        self.subTitleLabel.text = "\(model.file_size ?? 0)"
    }
    
    @objc func deleteAction() {
        deleteClosure?(self.model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
