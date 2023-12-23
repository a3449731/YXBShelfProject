//
//  MSDressCell.swift
//  YXBSwiftProject
//
//  Created by yangxiaobin on 2023/10/20.
//  Copyright © 2023 ShengChang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MSDressCell: UICollectionViewCell {
    private let bgImg: UIImageView = {
        let imageView = MyUIFactory.commonImageView(frame:CGRect(x: 0, y: 0, width: 108.fitScale(), height: 129.fitScale()), name: nil, placeholderImage: nil)
        return imageView
    }()
    
    private let topImg: UIImageView = {
        let imageView = MyUIFactory.commonImageView(frame:CGRect(x: 18.fitScale(), y: 14.fitScale(), width: 72.fitScale(), height: 72.fitScale()), placeholderImage: nil, contentMode: .scaleAspectFit)
        return imageView
    }()
    
    private let nameLab: UILabel = {
        let label = MyUIFactory.commonLabel(frame: CGRect(x: 5.fitScale(), y: 89.fitScale(), width: 100.fitScale(), height: 14.fitScale()), text: nil, textColor: .titleColor_black, font: .titleFont_14, lines: 1, textAlignment: .center)
        return label
    }()
    
    private let timeLab: UILabel = {
        let label = MyUIFactory.commonLabel(frame: CGRect(x: 5.fitScale(), y: 110.fitScale(), width: 100.fitScale(), height: 10.fitScale()), text: nil, textColor: .titleColor_gray, font: .subTitleFont_10, lines: 1, textAlignment: .center)
        return label
    }()
    
    private let useLab: UILabel = {
        let label = MyUIFactory.commonLabel(frame: CGRect(x: 3.5.fitScale(), y: 3.5.fitScale(), width: 45.fitScale(), height: 20.fitScale()), text: "装扮中", textColor: .titleColor_white, font: .subTitleFont_10, lines: 1, textAlignment: .center)
        label.backgroundColor = .backgroundColor_main
        label.roundCorners([.topLeft, .bottomRight], radius: 10.fitScale())
        return label
    }()
    
    private let buyLab: UILabel = {
        let label = MyUIFactory.commonLabel(frame: CGRect(x: 5.fitScale(), y: 110.fitScale(), width: 100.fitScale(), height: 10.fitScale()), text: "已购买", textColor: .titleColor, font: .subTitleFont_10, lines: 1, textAlignment: .center)
        return label
    }()
    
    private let priceBtn: UIButton = {
        let button = MyUIFactory.commonImageTextButton(title: nil, titleColor: .titleColor_black, titleFont: .titleFont_10, image: UIImage(named: "CUYuYinFang_shangcheng_图层 27")?.scaled(toWidth: 12), postion: .left, space: 2.5.fitScale())
        button.frame = CGRect(x: 5.fitScale(), y: 105.fitScale(), width: 100.fitScale(), height: 20.fitScale())
        button.isUserInteractionEnabled = false
        return button
    }()
    
//    var isMyBeiBao: Bool = false
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .backgroundColor_gray
        contentView.layerBorderWidth = 8
        contentView.addSubview(bgImg)
        bgImg.addSubview(topImg)
        bgImg.addSubview(nameLab)
        bgImg.addSubview(timeLab)
        bgImg.addSubview(useLab)
        bgImg.addSubview(buyLab)
        bgImg.addSubview(priceBtn)
    }
    
    func setup(model: MSDressModel, isMyBeiBao: Bool) {
        let image = model.img
        let name = model.name
        let isBuy = model.isyy
        let subs = model.subs
        var price = model.price
        if !subs.isEmpty {
            let subDic = subs[0]
            price = subDic.price
        }
        let time = model.endTime
        
        let isUsed = model.isUsed
        
        topImg.sd_setImage(with: URL(string: image), placeholderImage: nil)
        nameLab.text = name
        
        if isMyBeiBao {
            if time == nil || time!.isEmpty {
                timeLab.text = "永久使用"
            } else {
                if let time = time {
                    let day = Int(time)! / 1000 / 60 / 60 / 24
                    if day > 0 {
                        timeLab.text = "剩余\(day)天"
                    } else {
                        let hour = Int(time)! / 1000 / 60 / 60
                        if hour > 0 {
                            timeLab.text = "剩余(hour)小时"
                        } else {
                            let minute = Int(time)! / 1000 / 60
                            if minute > 0 {
                                timeLab.text = "剩余(minute)分钟"
                                
                            } else {
                                timeLab.text = "已过期"
                            }
                        }
                    }
                }
            }
            buyLab.isHidden = true
            priceBtn.isHidden = true
            useLab.isHidden = !model.isUsed
        } else {
            timeLab.text = ""
            buyLab.isHidden = !isBuy
            if isBuy {
                priceBtn.isHidden = true
            } else {
                priceBtn.isHidden = false
                priceBtn.setTitle(price, for: .normal)
            }
            useLab.isHidden = !isUsed
        }
    }
    
    func configChoose(isSelected: Bool) {
        contentView.layerBorderWidth = isSelected ? 1.0 : 0.0
        contentView.layerBorderColor = isSelected ? .borderColor_pink : .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
