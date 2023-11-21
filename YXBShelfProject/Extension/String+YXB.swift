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
