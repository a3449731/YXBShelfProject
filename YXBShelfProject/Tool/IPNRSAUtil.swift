//
//  IPNRSAUtil.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/18.
//


import Foundation
import CommonCrypto

class IPNRSAUtil {
    
    static let RSAPublicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrj2AgOYTsIZyOwK5VusYe3AKiz0XFf5D0smWfKZGylOsnGC/L8R/S2Q/qSwevZAQQOlqLY+Si+6ekHnp+1pARwZ31TpHqWMC4Zrd+kIRwfO9vZtoQufnxZJEVLBa+omovaUrK8j1nWfdYO7gSfi5uQ3hvyS6R8n5NMOfp+aecxwIDAQAB"
    
    static let RSAPrivateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKuPYCA5hOwhnI7ArlW6xh7cAqLPRcV/kPSyZZ8pkbKU6ycYL8vxH9LZD+pLB69kBBA6Wotj5KL7p6Qeen7WkBHBnfVOkepYwLhmt36QhHB8729m2hC5+fFkkRUsFr6iai9pSsryPWdZ91g7uBJ+Lm5DeG/JLpHyfk0w5+n5p5zHAgMBAAECgYEAhfK2ydI/DyKbGvYj57mhcHy07itJPY+BPRyArYmGQVl2VJrUzrXf8/8YJwUX5gAAEC+PfF+tJve3hzNoztl1t6uNV5z4mniiJj4vX7l+y8R4gEE35ktBV8WWpQ8ffu66rSPv4IPErIAehWKvw4JlYszR4yfbI/Gn2y7c98OvPRkCQQD3urKjWM1UDiTQBny97OMOL66UvHl/BU8+/qn7fuJWPDOjdPnB0vVm7mPFNLgsSF+rkjhucnKygtYS2mpV52zNAkEAsUmr7lZwW41TF8lY6TfVTL9CYCfjsNlKrJTkWCY90MRQrl71Oku8NJHOJhGSrFlUsJSuloEq2RS7PXNzwlqv4wJAagpDr0Iy2hkXzugH+3BsHMVyUH6A70tBibCO6HV+wvUQEZbf1gTMQNwoXuDbOTFdql5zw2tAB4OTyQwvWkguvQJAXWt6w76cukGANZqN1WbsaOKnsU+TtY7qwII8yQ5tqGKqORgklLFv3Suvu3OrHFJ+RAY08W3jDDzWZY0+xH1RDQJAX7uA8C8Gl/CCA36aUNenJriEnwX3mnQ7UK8iUtwAPR27o6WDsp5nKOy0n6XD47vBtvh+EMmcLdKWdXWIpR56gg=="
    
    private static func base64_encode_data(_ data: Data) -> String {
        let base64Data = data.base64EncodedData(options: [])
        if let base64String = String(data: base64Data, encoding: .utf8) {
            return base64String
        }
        return ""
    }
    
    private static func base64_decode(_ str: String) -> Data? {
        if let data = Data(base64Encoded: str, options: []) {
            return data
        }
        return nil
    }
    
    private static func stripPublicKeyHeader(_ d_key: Data) -> Data? {
        var c_key = [UInt8](d_key)
        var idx = 0
        
        if c_key[idx] != 0x30 { return nil }
        
        idx += 1
        
        if c_key[idx] > 0x80 { idx += Int(c_key[idx]) - 0x80 + 1 }
        else { idx += 1 }
        
        let seqiod: [UInt8] = [ 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00 ]
        if memcmp(&c_key[idx], seqiod, 15) != 0 { return nil }
        
        idx += 15
        
        if c_key[idx] != 0x03 { return nil }
        
        idx += 1
        
        if c_key[idx] > 0x80 { idx += Int(c_key[idx]) - 0x80 + 1 }
        else { idx += 1 }
        
        if c_key[idx] != 0x00 { return nil }
        
        return d_key.subdata(in: idx+1..<d_key.count)
    }
    
    private static func stripPrivateKeyHeader(_ d_key: Data) -> Data? {
        var c_key = [UInt8](d_key)
        var idx = 22
        
        if c_key[idx] != 0x04 { return nil }
        
        idx += 1
        
        var c_len = c_key[idx]
        var det = c_len & 0x80
        if det == 0 {
            c_len = c_len & 0x7f
        } else {
            let byteCount = c_len & 0x7f
            if Int(byteCount) + idx > c_key.count { return nil }
            var accum: UInt32 = 0
            var ptr = withUnsafeMutablePointer(to: &c_key[idx], { $0 })
            idx += Int(byteCount)
            var byteCountCopy = byteCount
            while byteCountCopy > 0 {
                accum = (accum << 8) + UInt32(ptr.pointee)
                ptr = ptr.successor()
                byteCountCopy -= 1
            }
            c_len = UInt8(accum)
        }
        
        return d_key.subdata(in: idx..<idx+Int(c_len))
    }
    
    private static func addPublicKey(_ key: String) -> SecKey? {
        var publicKey: SecKey?
        
        let key = key.replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        if let data = base64_decode(key),
           let strippedData = stripPublicKeyHeader(data) {
            
            let tag = "RSAUtil_PubKey"
            let d_tag = tag.data(using: .utf8)!
            
            var publicKeyAttributes: [CFString: Any] = [:]
            publicKeyAttributes[kSecClass] = kSecClassKey
            publicKeyAttributes[kSecAttrKeyType] = kSecAttrKeyTypeRSA
            publicKeyAttributes[kSecAttrApplicationTag] = d_tag
            publicKeyAttributes[kSecValueData] = strippedData
            publicKeyAttributes[kSecAttrKeyClass] = kSecAttrKeyClassPublic
            publicKeyAttributes[kSecReturnPersistentRef] = kCFBooleanTrue
            
            SecItemDelete(publicKeyAttributes as CFDictionary)
            
            var persistKey: CFTypeRef?
            let status = SecItemAdd(publicKeyAttributes as CFDictionary, &persistKey)
            
            if status != noErr && status != errSecDuplicateItem {
                return nil
            }
            
            publicKeyAttributes.removeValue(forKey: kSecValueData)
            publicKeyAttributes.removeValue(forKey: kSecReturnPersistentRef)
            publicKeyAttributes[kSecReturnRef] = kCFBooleanTrue
            publicKeyAttributes[kSecAttrKeyType] = kSecAttrKeyTypeRSA
            
            var keyRef: CFTypeRef?
            let cfPublicKey = publicKeyAttributes as CFDictionary
            let statusCopy = SecItemCopyMatching(cfPublicKey, &keyRef)
            if statusCopy == noErr {
                publicKey = (keyRef as! SecKey)
            }
        }
        
        return publicKey
    }
    
    private static func addPrivateKey(_ key: String) -> SecKey? {
        var privateKey: SecKey?
        
        let key = key.replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        if let data = base64_decode(key),
           let strippedData = stripPrivateKeyHeader(data) {
            
            let tag = "RSAUtil_PrivKey"
            let d_tag = tag.data(using: .utf8)!
            
            var privateKeyAttributes: [CFString: Any] = [:]
            privateKeyAttributes[kSecClass] = kSecClassKey
            privateKeyAttributes[kSecAttrKeyType] = kSecAttrKeyTypeRSA
            privateKeyAttributes[kSecAttrApplicationTag] = d_tag
            privateKeyAttributes[kSecValueData] = strippedData
            privateKeyAttributes[kSecAttrKeyClass] = kSecAttrKeyClassPrivate
            privateKeyAttributes[kSecReturnPersistentRef] = kCFBooleanTrue
            
            SecItemDelete(privateKeyAttributes as CFDictionary)
            
            var persistKey: CFTypeRef?
            let status = SecItemAdd(privateKeyAttributes as CFDictionary, &persistKey)
            
            if status != noErr && status != errSecDuplicateItem {
                return nil
            }
            
            privateKeyAttributes.removeValue(forKey: kSecValueData)
            privateKeyAttributes.removeValue(forKey: kSecReturnPersistentRef)
            privateKeyAttributes[kSecReturnRef] = kCFBooleanTrue
            privateKeyAttributes[kSecAttrKeyType] = kSecAttrKeyTypeRSA
            
            var keyRef: CFTypeRef?
            let statusCopy = SecItemCopyMatching(privateKeyAttributes as CFDictionary, &keyRef)
            if statusCopy == noErr {
                privateKey = (keyRef as! SecKey)
            }
        }
        
        return privateKey
    }
    
    private static func encryptData(_ data: Data, withKeyRef keyRef: SecKey) -> Data? {
        let srcbuf = [UInt8](data)
        let srclen = data.count
        let block_size = SecKeyGetBlockSize(keyRef) * MemoryLayout<UInt8>.size
        var outbuf = [UInt8](repeating: 0, count: block_size)
        let src_block_size = block_size - 11
        var ret = Data()
        var idx = 0
        while idx < srclen {
            let data_len = srclen - idx
            let len = data_len > src_block_size ? src_block_size : data_len
            var outlen = block_size
            srcbuf.withUnsafeBytes { srcPtr in
                let status = SecKeyEncrypt(keyRef, .PKCS1, srcPtr.baseAddress!.assumingMemoryBound(to: UInt8.self) + idx, len, &outbuf, &outlen)
                if status != errSecSuccess {
                    print("SecKeyEncrypt failed with status: \(status)")
                    return
                } else {
                    ret.append(contentsOf: outbuf[0..<outlen])
                }
            }
            idx += src_block_size
        }
        return ret
    }
    
    private static func decryptData(_ data: Data, withKeyRef keyRef: SecKey) -> Data? {
        let srcbuf = [UInt8](data)
        let srclen = data.count
        let block_size = SecKeyGetBlockSize(keyRef) * MemoryLayout<UInt8>.size
        var outbuf = [UInt8](repeating: 0, count: block_size)
        let src_block_size = block_size
        var ret = Data()
        var idx = 0
        while idx < srclen {
            let data_len = srclen - idx
            let len = data_len > src_block_size ? src_block_size : data_len
            var outlen = block_size
            srcbuf.withUnsafeBytes { srcPtr in
                let status = SecKeyDecrypt(keyRef, .PKCS1, srcPtr.baseAddress!.assumingMemoryBound(to: UInt8.self) + idx, len, &outbuf, &outlen)
                if status != errSecSuccess {
                    print("SecKeyDecrypt failed with status: \(status)")
                    return
                } else {
                    let idxFirstZero = outbuf.withUnsafeBufferPointer { buffer -> Int in
                        for (index, value) in buffer.enumerated() {
                            if value == 0 {
                                return index
                            }
                        }
                        return -1
                    }
                    let idxNextZero = outbuf.withUnsafeBufferPointer { buffer -> Int in
                        for (index, value) in buffer.enumerated() {
                            if value == 0 && index > idxFirstZero {
                                return index
                            }
                        }
                        return outlen
                    }
                    ret.append(contentsOf: outbuf[idxFirstZero+1..<idxNextZero])
                }
            }
            idx += src_block_size
        }
        return ret
    }
    
    static func encryptString(_ str: String, privateKey privKey: String) -> String? {
        guard let data = str.data(using: .utf8),
              let keyRef = addPrivateKey(privKey),
              let encryptedData = encryptData(data, withKeyRef: keyRef) else {
            return nil
        }
        
        let encryptedString = base64_encode_data(encryptedData)
        return encryptedString
    }
    
    static func decryptString(_ str: String, privateKey privKey: String) -> String? {
        guard let data = base64_decode(str),
              let keyRef = addPrivateKey(privKey),
              let decryptedData = decryptData(data, withKeyRef: keyRef),
              let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            return nil
        }
        
        return decryptedString
    }
    
    static func encryptString(_ str: String, publicKey pubKey: String) -> String? {
        guard let data = str.data(using: .utf8),
              let keyRef = addPublicKey(pubKey),
              let encryptedData = encryptData(data, withKeyRef: keyRef) else {
            return nil
        }
        
        let encryptedString = base64_encode_data(encryptedData)
        return encryptedString
    }
    
    static func decryptString(_ str: String, publicKey pubKey: String) -> String? {
        guard let data = base64_decode(str),
              let keyRef = addPublicKey(pubKey),
              let decryptedData = decryptData(data, withKeyRef: keyRef),
              let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            return nil
        }
        
        return decryptedString
    }
    
    static func rsaVerifySignature(_ signature: String, plainString: String, withPublicKey publickey: String) -> Bool {
        guard let signatureData = base64_decode(signature),
              let plainData = plainString.data(using: .utf8),
              let publicKey = addPublicKey(publickey) else {
            return false
        }
        let signedHashBytesSize = SecKeyGetBlockSize(publicKey)
        var signedHashBytes = [UInt8](repeating: 0, count: signedHashBytesSize)
        let hashBytesSize = Int(CC_SHA1_DIGEST_LENGTH)
        var hashBytes = [UInt8](repeating: 0, count: hashBytesSize)
        CC_SHA1((plainData as NSData).bytes, CC_LONG(plainData.count), &hashBytes)
        var signedHashBytesSizeVar = signedHashBytesSize
        let status = SecKeyRawVerify(publicKey, .PKCS1SHA1, hashBytes, hashBytesSize, &signedHashBytes, signedHashBytesSizeVar)
        return status == errSecSuccess
    }
    
    static func rsaSignString(_ plainString: String, withPrivateKey privateKey: String) -> String? {
        guard let plainData = plainString.data(using: .utf8),
              let privateKey = addPrivateKey(privateKey) else {
            return nil
        }
        
        var signedHashBytesSize = SecKeyGetBlockSize(privateKey)
        var signedHashBytes = [UInt8](repeating: 0, count: signedHashBytesSize)
        
        let hashBytesSize = Int(CC_SHA1_DIGEST_LENGTH)
        var hashBytes = [UInt8](repeating: 0, count: hashBytesSize)
        
        CC_SHA1((plainData as NSData).bytes, CC_LONG(plainData.count), &hashBytes)
        
        SecKeyRawSign(privateKey, .PKCS1SHA1, hashBytes, hashBytesSize, &signedHashBytes, &signedHashBytesSize)
        
        let signedHashData = Data(bytes: signedHashBytes, count: signedHashBytesSize)
        let base64SignedHash = base64_encode_data(signedHashData)
        
        return base64SignedHash
    }
    
    static func queryMD5String(_ dictionary: [String: Any]) -> String {
        let queryString = generateQueryString(dictionary)
        let md5String = generateMD5String(input: queryString)
        return md5String
    }
    
    private static func generateMD5String(input: String) -> String {
        guard let data = input.data(using: .utf8) else {
            return ""
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            if let baseAddress = bytes.baseAddress {
                CC_MD5(baseAddress, CC_LONG(data.count), &digest)
            }
        }
        
        let md5String = digest.map { String(format: "%02x", $0) }.joined()
        return md5String
    }
    
    private static func generateQueryString(_ dictionary: [String: Any]) -> String {
        let filteredKeyValuePairs = dictionary.sorted { $0.key < $1.key }
            .filter { !($0.value is NSNull) && !($0.value is String && ($0.value as! String).isEmpty) }
            .map { "\($0.key)=\($0.value)" }
        
        let queryString = filteredKeyValuePairs.joined(separator: "&")
        return queryString
    }
    
    static func signAndSecret(_ dictionary: [String: Any]) -> [String: Any]? {
        guard !dictionary.isEmpty else {
            return nil
        }
        
        let sign = queryMD5String(dictionary)
        var mutableDictionary = dictionary
        mutableDictionary["sign"] = sign
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: mutableDictionary),
           let jsonString = String(data: jsonData, encoding: .utf8),
           let encryptedString = encryptString(jsonString, publicKey: RSAPublicKey) {
            let parameters = ["data": encryptedString]
            return parameters
        }
        
        return nil
    }
}

