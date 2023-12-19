//
//  LQMaiWeiModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import HandyJSON

@objcMembers class LQMaiWeiModel: NSObject {
    required override init() {}
    /*
     // 201消息推的是整个魅力值，要自己找对应位置拆分出来
     Rtm频道消息:{"hotnum":"100","hotsum":"3073128","meiNum":"0","dataList":[{"mai":"5","meiNum":"100","id":"e4a7c97b69d946c4b93ce44034e93716"},{"mai":"0","meiNum":"0","id":"fd56a01b47f949f5bcb1690d62f4aa8e"}],"type":"201"}
     */
    /// 麦位的魅力值
    @objc dynamic var meiNum: String?
    /// 这好像没用上
//    var meiliNum: String?
    /// 战力值，这是在pk状态下才有值。
    @objc dynamic var combatValue: String?
    // pk状态 1未开始 2已开始 3已结束 4异常结束(提前结束)
    var pkType: String?
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
    var isAdmin: Bool = false
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
    
    /// 房间类型
    var roomType: LQRoomType = .merchant_9
    
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
    
    // 需要展示表情的url，在发送表情消息后收到
    @objc dynamic var emotionUrl: String?
    
    // 给pk的送礼麦位用的，真不想用oc
    @objc func giftMaiRank_oc() -> Int {
        self.mai?.giftPkSort ?? 10
    }
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
    
    // 5人房的图片配置
    var iconImageName_5: String? {
        switch self {
        case .host: return "CUYuYinFang_zhibojian_kongxian"
        case .one: return "CUYuYinFang_roomDetail_huangjin"
        case .two, .three, .four: return "CUYuYinFang_roomDetail_baiyin"
        default: return nil
        }
    }
    
    // 5人房的名字配置
    var titleName_5: String? {
        switch self {
        case .one: return "黄金守护"
        case .two, .three, .four: return "白银守护"
        default: return nil
        }
    }
    
    // pk中的序号
    var pkSort: String? {
        switch self {
        case .one: return "1"
        case .two: return "2"
        case .three: return "1"
        case .four: return "2"
        case .five: return "3"
        case .six: return "4"
        case .seven: return "3"
        case .boss: return "4"
        default:
            return nil
        }
    }
    
    // 如果是pk状态下的话，在送礼麦位中的排序,
    var giftPkSort: Int {
        switch self {
        case .host: return 9
        case .one: return 1
        case .two: return 2
        case .three: return 5
        case .four: return 6
        case .five: return 3
        case .six: return 4
        case .seven: return 7
        case .boss: return 8
        }
    }
}

// 标1,2,3主要是为了给OC用，方便转化，
enum LQRoomType: String {
    /// 商业房 9人房
    case merchant_9 = "2"
    /// 商业房 5人房
    case merchant_5 = "1"
    /// 个播房，9人，不在首页展示，可搜索到
    case personal = "3"
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

//// 性别
//public enum SexType: Int, HandyJSONEnum {
//    case male = 1     // 男
//    case female = 2   // 女
//
//    var defaultHeaderImage: UIImage? {
//        switch self {
//        case .male: return UIImage(named: "login_icon_boy")
//        case .female: return UIImage(named: "login_icon_girl")
//        }
//    }
//
//    var radarColor: UIColor {
//        switch self {
//        case .male: return UIColor(rgb: 0xFD88D7, alpha: 1)
//        case .female: return UIColor(rgb: 0xFD88D7, alpha: 1)
//        }
//    }
//}

// PK中的战力值
/*
Rtm频道消息:{"campB":"400","dataList":[{"mai":"0","combatValue":"1300","id":"16493c6c81194643b03406269770b16f"},{"mai":"1","combatValue":"1500","id":"85e55d4ff8684c588f4158137653e8c2"},{"mai":"3","combatValue":"200","id":"fd56a01b47f949f5bcb1690d62f4aa8e"}],"type":"210"}
*/
class LQPKCombatModel: HandyJSON {
    /// 类型，应该是210
    var type: String?
    /// 红方总战力
    var campA: Int?
    /// 蓝方总战力
    var campB: Int?
    var dataList: [LQPKCombatValueModel]?
    // 红方前三
    var bestContributionA: [LQPKCombatSortModel]?
    // 蓝方前三
    var bestContributionB: [LQPKCombatSortModel]?
    
    
    // 调整映射层级
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.bestContributionA <-- "data.bestContributionA"
        mapper <<< self.bestContributionB <-- "data.bestContributionB"
    }
    
    required init() {}
    
    // 战力值
    class LQPKCombatValueModel: HandyJSON {
        var mai: String?
        var combatValue: String?
        var id: String?
        
        required init() {}
    }
    
    // 前三头像
    class LQPKCombatSortModel: HandyJSON {
        var headImg: String?
        var fromUserId: String?
        var currency: String?
        var userId: String?
        var camp: Int?
        
        required init() {}
    }
}


class LQMaiWeiMessageModel: HandyJSON {
    required init() {}
    
    var type: String?
    var mai: String?
    
    var maiName: String?
    var uid: String?
    var url: String?
}


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
