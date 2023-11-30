//
//  LQMaiWeiProtocol.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/29.
//

import Foundation


@objc protocol LQMicrophoneUserViewDelegate: NSObjectProtocol {
    // 点击了麦位的icon。
    @objc optional func microphoneUserView(view: LQMicrophoneUserView, didTapMaiWeiIcon: LQMaiWeiModel?)
    
    // 麦上有用户，点击的是userheader。
    @objc optional func microphoneUserView(view: LQMicrophoneUserView, didTapUserHeader: LQMaiWeiModel?)
}


@objc protocol LQMaiWeiViewDelegate: NSObjectProtocol {
    // 点击了麦位的icon。
    @objc optional func maiWeiView(view: LQMaiWeiView, didTapMaiWeiIcon: LQMaiWeiModel?)
    
    // 麦上有用户，点击的是userheader。
    @objc optional func maiWeiView(view: LQMaiWeiView, didTapUserHeader: LQMaiWeiModel?)
    
    // 麦上有用户，点击的是魅力值。
    @objc optional func maiWeiView(view: LQMaiWeiView, didTapCharmView: LQMaiWeiModel?)
}


@objc protocol LQMaiWeiCellDelegate: NSObjectProtocol {
    // 点击了麦位的icon。
    @objc optional func maiWeiCell(didTapMaiWeiIcon: LQMaiWeiCell, model: LQMaiWeiModel)
    
    // 麦上有用户，点击的是userheader。
    @objc optional func maiWeiCell(didTapUserHeader: LQMaiWeiCell, model: LQMaiWeiModel)
    
    // 麦上有用户，点击的是魅力值。
    @objc optional func maiWeiCell(didTapCharmView: LQMaiWeiCell, model: LQMaiWeiModel)
}

// 给tableview留的协议，这是要给oc用的。
@objc protocol LQAllMailWeiViewDelegate: NSObjectProtocol {
    // 点击了麦位的icon。 isHostMai:表示是否是主持麦。 roomType:房间类型，因为是给OC用就不能用枚举传递了
    @objc optional func mailWeiList(didTapMaiWeiIcon: LQAllMailWeiView, model: LQMaiWeiModel, isHostMai: Bool, roomType: String)
    
    // 麦上有用户，点击的是userheader。 isHostMai:表示是否是主持麦。 roomType:房间类型，因为是给OC用就不能用枚举传递了
    @objc optional func mailWeiList(didTapUserHeader: LQAllMailWeiView, model: LQMaiWeiModel, isHostMai: Bool, roomType: String)
    
    // 麦上有用户，点击的是魅力值。 isHostMai:表示是否是主持麦。 roomType:房间类型，因为是给OC用就不能用枚举传递了
    @objc optional func mailWeiList(didTapCharmView: LQAllMailWeiView, model: LQMaiWeiModel, isHostMai: Bool, roomType: String)
}
