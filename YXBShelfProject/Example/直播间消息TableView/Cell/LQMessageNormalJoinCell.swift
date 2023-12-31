//
//  LQMessageNormalJoinCell.swift
//  YXBSwiftProject
//
//  Created by yangxiaobin on 2023/11/9.
//  Copyright © 2023 ShengChang. All rights reserved.
//

import UIKit
import YYText

/// 普通用户进入，当没有贵族等级时
class LQMessageNormalJoinCell: LQOnlyBubbleCell {
    
    var model: LQMessageModel?
    
    // 调整文字的边距
    var titleInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12) {
        didSet {
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(titleInset.top)
                make.left.equalTo(titleInset.left)
                make.bottom.equalTo(-titleInset.bottom)
            }
        }
    }
        
    let iconImageView: UIImageView = {
        let imageView = MyUIFactory.commonImageView(placeholderImage: nil)
        return imageView
    }()

    let titleLabel: YYLabel = {
        let yyLabel = YYLabel()
        yyLabel.preferredMaxLayoutWidth = 250
        yyLabel.numberOfLines = 0
        yyLabel.lineBreakMode = .byWordWrapping
        return yyLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.bubbleImageView.backgroundColor = UIColor(hex: 0x000000, transparency: 0.2)
        
        bubbleBG.addSubview(titleLabel)
                
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(titleInset.top)
            make.left.equalToSuperview().offset(titleInset.left)
            make.bottom.equalToSuperview().offset(-titleInset.bottom)
        }
     
    }
    
    override func setup(model: LQMessageModel) {
        self.model = model
        
        if model.type == .joinRoom || model.type == .follow {
                                    
            guard let joinRoomAtt = model.joinRoomAtt else {
                return
            }
            
            let att = NSMutableAttributedString()
            
            // 图片的绘制放到这里，不然黑屏的时候绘不出来
            // 财富等级
            if let rich = model.caiLevel, !rich.isEmpty,
               let richLevel = Int(rich) {
                // 选择制作截图添加图片。如果是制作背景图，会因为字体宽度不一样，很难占位置。
                let richView: HonourTagView = HonourTagView(frame: CGRectMake(-38, -18, 36, 16))
                richView.imageName = VipPictureConfig.richBubble(level: richLevel) ?? ""
                richView.title = rich
                richView.isOpaque = false
                UIApplication.shared.currentUIWindow()?.addSubview(richView)
                let shotImage = richView.yxb_snapshotImage()
                richView.removeFromSuperview()
                                                           
                let richAtt = NSMutableAttributedString()
                let attachment = NSMutableAttributedString.yy_attachmentString(withContent: shotImage, contentMode: .center, attachmentSize: shotImage?.size ?? CGSizeMake(10, 10), alignTo: .titleFont_14, alignment: .center)
                // 将YYTextAttachment对象插入到指定位置
                richAtt.append(attachment)
                att.append(richAtt)
                att.yy_appendString(" ")
            }
            
            // 魅力等级
            if let charm = model.meiLevel, !charm.isEmpty,
               let charmLevel = Int(charm) {
                // 选择制作截图添加图片。如果是制作背景图，会因为字体宽度不一样，很难占位置。
                let charmView: HonourTagView = HonourTagView(frame: CGRectMake(-38, -18, 36, 16))
                charmView.imageName = VipPictureConfig.charmBubble(level: charmLevel) ?? ""
                charmView.title = charm
                // 不写这个的话，绘制出来会多一层黑色的背景
                charmView.isOpaque = false
                UIApplication.shared.currentUIWindow()?.addSubview(charmView)
                let shotImage = charmView.yxb_snapshotImage()
                charmView.removeFromSuperview()
                                                           
                let richAtt = NSMutableAttributedString()
                let attachment = NSMutableAttributedString.yy_attachmentString(withContent: shotImage, contentMode: .center, attachmentSize: shotImage?.size ?? CGSizeMake(10, 10), alignTo: .titleFont_14, alignment: .center)
                // 将YYTextAttachment对象插入到指定位置
                richAtt.append(attachment)
                att.append(richAtt)
                att.yy_appendString("  ")
            }
            
            // 欢迎进入房间
            var textRoomAtt = NSMutableAttributedString(attributedString: joinRoomAtt)
            if let nickname = model.nickname {
                let range = (joinRoomAtt.string as NSString).range(of: nickname)
                if range.location != NSNotFound {
                    // 找到了字符串在joinRoomAtt中的NSRange
                    textRoomAtt.yy_setTextHighlight(range, color: .titleColor_yellow, backgroundColor: .clear) {[weak self] _, att, _, _ in
                        self?.tapNickNameAction(att)
                    }
                }
            }
            att.append(textRoomAtt)

                
            // 欢迎按钮，只在加入公会，且没点过欢迎的时候展示
            if model.hasClipWelcome || UserConst.isGh == false || UserConst.uid == model.uid {
                
            } else {
                // 创建一个NSMutableAttributedString
                let welcomeImageAtt = NSMutableAttributedString()
                // 创建一个UIImage对象
                let image = UIImage(named: "CUYuYinFang_guizu_join_welcome")
                // 创建一个YYTextAttachment对象，并将UIImage对象添加到YYTextAttachment中
                let attachment = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: image?.size ?? CGSizeMake(10, 10), alignTo: .titleFont_14, alignment: .center)
                // 将YYTextAttachment对象插入到指定位置
                welcomeImageAtt.append(attachment)

                // 为图片添加点击事件
                let highlight: YYTextHighlight = YYTextHighlight()
                highlight.tapAction = { [weak self] containerView, text, range, rect in
                    self?.highlightTapAction(text)
                }
                welcomeImageAtt.yy_setTextHighlight(highlight, range: welcomeImageAtt.yy_rangeOfAll())
                att.append(welcomeImageAtt)
            }
            
            titleLabel.attributedText = att
        }
        
    }
    
    // MARK: 点击了欢迎
    private func highlightTapAction(_ text: NSAttributedString) {
        if let safeModel = self.model {
            self.delegate?.tableView?(cell: self, didTapWellcomeModel: safeModel)
        }
    }
    
    // MARK: 点击了昵称
    private func tapNickNameAction(_ text: NSAttributedString) {
        if let safeModel = self.model {
            self.delegate?.tableView?(cell: self, didTapNickNameModel: safeModel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // MARK: 重要，强制刷新， 这样才能在layoutSubviews拿到titleLabel正确的宽度. 这个地方可以优化一下，只在可见的时候去刷新不可以吗 https://www.jianshu.com/p/9fa58c5febd3
        // 注意是self.contentView，不要写self.setNeedsLayout()，会循环
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
  
//        debugPrint("告诉我这到底执行了多少次", self.titleLabel.frame.size)
        // 修改气泡框的大小
        self.bubbleImageView.frame = CGRectMake(0, 0, self.titleLabel.width + titleInset.left + titleInset.right, self.bubbleBG.height)
        self.bubbleImageView.layerCornerRadius = self.bubbleImageView.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
