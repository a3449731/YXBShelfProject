//
//  YXBRoom.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2024/3/19.
//

import Foundation

@objcMembers
class YXBRoom: NSObject {
    var roomId: String = ""
    var mxSession: String = ""
    
    func setGroupAnnouncementWithContent(_ parmas: [String: Any], complete:(String) -> Void, failure:(Error?) -> Void) {
        complete("123")
    }
}
