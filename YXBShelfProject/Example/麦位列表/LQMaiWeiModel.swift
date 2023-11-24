//
//  LQMaiWeiModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import HandyJSON

@objc class LQMaiWeiModel: NSObject {
    required override init() {}
    /// 麦位的魅力值
    var meiNum: String?
    /// 这好像没用上
//    var meiliNum: String?
    /// 头像
    var uimg: String?
    /// 头像框
    var headKuang: String?
    /// 用户id
    var id: String?
    /// 年龄
    var nianl: String?
    /// 昵称
    var uname: String?
    /// 是否房主
    var isFz: String?
    /// 是否管理
    var isAdmin: String?
    /// 是否禁言
    var isJy: String?
    /// 麦位下标
    var mai: String?
    /// 这好像也是麦位下标
    var maiNo: String?
    /// 性别 1男 2女
    var isex: String?
    /// 是否闭麦
    var isb: String?
    /// 财富等级
    var caiLevel: String?
}

extension LQMaiWeiModel: HandyJSON {
    
}

//"vipInfo" : {
//
//},
//"meiNum" : "0",
//"isAdmin" : "0",
//"uimg" : "https:\/\/lanqi123.oss-cn-beijing.aliyuncs.com\/file\/21331_7badd52d4fb74b5b8b4c086e4888210b_ios_1698907260.png",
//"id" : "7badd52d4fb74b5b8b4c086e4888210b",
//"nianl" : 0,
//"maiNo" : "2",
//"uname" : "辰亦儒",
//"isFz" : "1",
//"isJy" : "0",
//"mai" : "2",
//"isex" : "1",
//"meiliNum" : "0",
//"isb" : "1",
//"headKuang" : "https:\/\/lanqi123.oss-cn-beijing.aliyuncs.com\/file\/1699241663797.webp",
//"caiLevel" : 101
