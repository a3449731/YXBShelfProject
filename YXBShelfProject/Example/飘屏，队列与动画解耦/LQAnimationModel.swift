//
//  LQAnimationModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/22.
//

import Foundation
import HandyJSON

// 动画所需的数据模型
struct LQAnimationModel: Equatable {
    /// 声网消息类型
    var type: String?
    /// 礼物飘屏范围 1房间内 2同品类 3全直播 4全派对 5全站
    var scopeFloat: FloatingScreenType.FloatScopeType?
    /// 礼物图片
    var img: String?
    /// 礼物数量
    var num: String?
    /// 房间id
    var houseId: String?
    /// 打赏人
    var tippingUser: FloatUserModel?
    /// 被打赏人
    var byTippingUser: FloatUserModel?
    /// 用户id
    var id: String?
    /// 昵称
    var nickname: String?
    /// 头像
    var headImg: String?
    /// 用户号（有靓号则展示靓号）
    var custNo: String?
    
    
    // 贵族升级
    /// 名称
    var vipName: String?
    /// 等级
    var vipLevel: Int?
    /// 图标
    var vipIcon: String?
    /// 图像
    var vipImg: String?
    
    /// 下面是送礼的，起另一个模型就太麻烦了
    /// floatType 飘屏类型 1礼物飘屏 2贵族升级飘屏 3红包飘屏 4大礼物
    var floatType: FloatingScreenType? //":4,
//    var houseId: String? //":"50616500",
//    var headImg: String? //":"https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1690792476235.jpg",
//    var nickname: String? //":"addis",
    var jueName: String? //":"伯爵",
//    var id: String? //":"85e55d4ff8684c588f4158137653e8c2",
    var isex: String? //":"1",
//    var type: String? //":"409",
//    var scopeFloat: String? //":5
    /// 送大礼物有的模型
    var gift: GiftModel?
    
    struct GiftModel: Equatable, HandyJSON {
        var giftId: String? //":"a8644e5292cd43bbb90778b45360de88",
        var giftImg: String? //":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1700120871014.png",
        var giftName: String? //":"相约巴黎",
        var num: String? //":133
    }
    
    struct FloatUserModel: Equatable, HandyJSON {
        var custNo: String?
        var headImg: String?
        var nickname: String?
        var id: String?
    }
}

extension LQAnimationModel: HandyJSON {
    
}

enum FloatingScreenType: Int, HandyJSONEnum {
//    floatType 飘屏类型 1礼物飘屏 2贵族升级飘屏 3红包飘屏 4大礼物
    // 当为1时候，要和FloatScopeType结合起来，样式不一样
    case gift = 1
    case nobble = 2
    case redPacket = 3
    case bigGift = 4
    
    // 获取底图
    func bgImageName(nobbleLevel: Int, scopeFloat: Int) -> String? {
        switch self {
        case .gift:
            if let type = FloatScopeType(rawValue: scopeFloat) {
                return type.bgImageName
            } else {
                return nil
            }
        case .nobble:
            if nobbleLevel == 6 {
                return "float_nobble_type_6"
            } else if nobbleLevel == 7 {
                return "float_nobble_type_7"
            }
        case .bigGift: return "float_big_type_1"
        default:
            return nil
        }
        return nil
    }
    
    enum FloatScopeType: Int, HandyJSONEnum {
        /// 房间
        case room = 1
        /// 品类
        case kind = 2
        /// 直播
        case live = 3
        /// 派对
        case party = 4
        /// 全站
        case all = 5
        
        var bgImageName: String {
            switch self {
            case .room: "float_gift_type_1"
            case .kind: "float_gift_type_2"
            case .live: "float_gift_type_3"
            case .party: "float_gift_type_4"
            case .all: "float_gift_type_5"
            }
        }
    }
}
