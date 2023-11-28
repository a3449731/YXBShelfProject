//
//  LQMaiWeiModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import HandyJSON

@objc class LQMaiWeiModel: NSObject {
    required override init() {}
    /*
     // 201消息推的是整个魅力值，要自己找对应位置拆分出来
     Rtm频道消息:{"hotnum":"100","hotsum":"3073128","meiNum":"0","dataList":[{"mai":"5","meiNum":"100","id":"e4a7c97b69d946c4b93ce44034e93716"},{"mai":"0","meiNum":"0","id":"fd56a01b47f949f5bcb1690d62f4aa8e"}],"type":"201"}
     */
    /// 麦位的魅力值
    @objc dynamic var meiNum: String?
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
    var isFz: Bool?
    /// 是否管理
    var isAdmin: Bool?
    /// 是否禁言
    var isJy: Bool?
    /// 麦位下标
    var mai: MaiWeiIndex?
    /// 这好像也是麦位下标
    var maiNo: String?
    /// 性别 1男 2女
    var isex: SexType?
    /// 是否闭麦
    @objc dynamic var isb: Bool = false
    /// 是否正在说话，yes的话就会有麦波
    @objc dynamic var isSpeaking: Bool = false
    /// 财富等级
    var caiLevel: String?
    
    // MARK: 下面这两个是对麦位而言，不是对用户。由接口里biList，suoList推演得到，或者消息推送里转化得出
    /*
     // 20: 麦位被锁,关闭。， 21: 麦位解锁，打开
     Rtm频道消息:{
     "type" : "20",
     "mai" : "2"
     }
     */
    // 麦位是否被锁了
    @objc dynamic var isMaiWeiLock: Bool = false
 
    /*
     // 24: 麦位禁言， 25: 麦位不禁言
     Rtm频道消息:{
     "type" : "24",
     "mai" : "2"
     }
     */
    // 麦位是否被禁言了。
    @objc dynamic var isMaiWeiMute: Bool = false

    /*
     // 29: 修改了麦位名字
     Rtm频道消息:{
     "type" : "29",
     "mai" : "2",
     "maiName" : "在下"
     }
     // 这是接口里返回，啥都不统一，真是些狗玩意
     "maiweiNameList" : [
       {
         "name" : "不是说我",
         "id" : "a7e79ab70e914d8c820df6fa669ff172",
         "maino" : "4"
       }
     ],
     */
    // 打平到同一层级
    @objc dynamic var name: String?
    
}

extension LQMaiWeiModel: HandyJSON {
    
}

// 麦位下标
enum MaiWeiIndex: String, CaseIterable, HandyJSONEnum {
    /// 主持位
    case host = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    /// 老板位
    case boss = "8"
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

// 性别
public enum SexType: Int, HandyJSONEnum {
    case male = 1     // 男
    case female = 2   // 女
    
    var defaultHeaderImage: UIImage? {
        switch self {
        case .male: return UIImage(named: "login_icon_boy")
        case .female: return UIImage(named: "login_icon_girl")
        }
    }
    
    var radarColor: UIColor {
        switch self {
        case .male: return UIColor(rgb: 0xFD88D7, alpha: 1)
        case .female: return UIColor(rgb: 0xFD88D7, alpha: 1)
        }
    }
}
