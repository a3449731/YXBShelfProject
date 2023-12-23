//
//  LQMessageCellProtocol.swift
//  YXBSwiftProject
//
//  Created by yangxiaobin on 2023/11/10.
//  Copyright © 2023 ShengChang. All rights reserved.
//

import Foundation

// 给cell用的协议，倒是不用暴露给objc
@objc protocol LQMessageCellProtocol: NSObjectProtocol {
    // 点击了欢迎
    @objc optional func tableView(cell: LQMessageCell, didTapWellcomeModel: LQMessageModel)
    /// 点击了头像
    @objc optional func tableView(cell: LQMessageBaseCell, didTapHeaderModel: LQMessageModel)
    /// 点击了进入房间消息中的昵称
    @objc optional func tableView(cell: LQMessageCell, didTapNickNameModel: LQMessageModel)
}

// 给tableview留的协议，这是要给oc用的。
@objc protocol LQMessageTableViewProtocol: NSObjectProtocol {
    // 点击了欢迎
    @objc optional func tableViewDidTapWellcome(model: LQMessageModel)
    /// 点击了头像
    @objc optional func tableViewDidTapHeader(model: LQMessageModel)
    /// 点击了进入房间消息中的昵称
    @objc optional func tableViewdidTapNickName(model: LQMessageModel)
}
