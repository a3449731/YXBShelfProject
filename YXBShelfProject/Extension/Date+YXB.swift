//
//  Date+YXB.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/21.
//

import Foundation


public let kMinute: TimeInterval = 60
public let kHour: TimeInterval = 60 * kMinute
public let kDay: TimeInterval = 24 * kHour

extension Date {
    
    static func monentsShowDate(seconds: TimeInterval) -> String {
        let currentTimeInterval = Date().timeIntervalSince1970
        let offset = currentTimeInterval - seconds
        if offset <= kMinute {
             return "1分钟前"
        }
        if offset < kHour {
            return "\(Int(offset/kMinute))分钟前"
        }
        if offset < kDay {
            return "\(Int(offset/kHour))小时前"
        }
        if offset < 6 * kDay {
            return "\(Int(offset/kDay))天前"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date(timeIntervalSince1970: seconds))
    }
    
    
    static func getDataString(seconds: TimeInterval, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: seconds))
    }
    
    
    static func fromDateToString(date:Date, format: String = "yyyy-MM-dd") -> String {
        
        let dformatter = DateFormatter()
        
        dformatter.dateFormat = format
        
        let dateStr = dformatter.string(from: date)
        
        return dateStr
        
    }
    
    static func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    
    // 计算两个日期之间的间隔
    static func dateInterval(startTime:String,endTime:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date1 = dateFormatter.date(from: startTime),
              let date2 = dateFormatter.date(from: endTime) else {
            return -1
        }
        let components = NSCalendar.current.dateComponents([.second], from: date1, to: date2)
        //如果需要返回月份间隔，分钟间隔等等，只需要在dateComponents第一个参数后面加上相应的参数即可，示例如下：
        //    let components = NSCalendar.current.dateComponents([.month,.day,.hour,.minute], from: date1, to: date2)
        return components.second!
    }

}

