//
//  GroupNoticeModel.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/2/5.
//

import Foundation
import SwiftyJSON

@objcMembers
class GroupNoticeEvent: NSObject {
    var content: GroupNoticeAnnouncement?
    var event_id: String?
    var origin_server_ts: UInt?
    var sender: String?
    var state_key: String?
    var type: String?
    var depth: Int?
}

@objcMembers
class GroupNoticeAnnouncement: NSObject {
    var announcement: GroupNoticeModel?
}

@objcMembers
class GroupNoticeModel: NSObject {
    var content: String?
    var sourceRoomId: String?
    var file_list: [GroupNoticeFileModel] = []
    
    class func model(fromJSON dictionaries: Any!) -> GroupNoticeModel {
        let model = GroupNoticeModel()
        let json = JSON(dictionaries)
        model.content = json["content"].string
        model.sourceRoomId = json["sourceRoomId"].string
        if let file_list = json["file_list"].arrayObject {
            model.file_list = GroupNoticeFileModel.models(fromJSON: file_list)
        }
        return model;
    }
}

@objcMembers
class GroupNoticeFileModel: NSObject {
    var type: String?
    var file_name: String?
    var file_size: NSNumber?
    var file_url: String?
    var id: String?
    
    class func models(fromJSON array: [Any]) -> [GroupNoticeFileModel] {
        var fileList: [GroupNoticeFileModel] = []
        for dic in array {
            let json = JSON(dic)
            let model = GroupNoticeFileModel()
            model.type = json["type"].string
            model.file_name = json["file_name"].string
            model.file_size = json["file_size"].number
            model.file_url = json["file_url"].string
            model.id = json["id"].string
            fileList.append(model)
        }
        return fileList
    }
}
