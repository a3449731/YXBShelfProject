//
//  String+YXB.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import Foundation
import CommonCrypto


extension String {
    var MD5ForLower32Byte: String {
           let utf8 = cString(using: .utf8)
           var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
           CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
           return digest.reduce("") { $0 + String(format: "%02x", $1)}
       }

       var md5: String {
               let utf8 = cString(using: .utf8)
               var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
               CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
               return digest.reduce("") { $0 + String(format: "%02X", $1)
           }
       }
}

extension String {
    // 格式化，随便写的，不配存于世。
    func formatNumberString() -> String {
        guard let number = Double(self) else {
            return "0"
        }
        
        if number > 10000 {
            // 去尾，保留一位小数
            let round = (number / 10000).rounded(numberOfDecimalPlaces: 1, rule: .down)
            let formattedNumber = String(format: "%.1fw", round)
            return formattedNumber
        } else {
            return self
        }
    }
}
