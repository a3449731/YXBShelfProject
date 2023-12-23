//
//  FileManager+YXB.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/21.
//

import Foundation

extension FileManager {
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()

    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()

    static let libDirectory: URL = {
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls[0]
    }()

    static public func isFileExists(filePath: String, isDirectory: Bool) -> Bool {
         var objectBool = ObjCBool.init(isDirectory)
         return FileManager.default.fileExists(atPath: filePath, isDirectory: &objectBool)
    }
    
    static public func isFileExists(filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }

    @discardableResult
    static public func deleteFile(at filePath: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePath)
            print("\(filePath) 文件夹删除成功")
            return true
        } catch {
            print("\(filePath) 文件夹删除失败")
            return false
        }
    }

    @discardableResult
    static public func createFileDirectory(filePath: String, withIntermediateDirectories: Bool) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
            print("filePath 文件夹创建成功")
            return true
        } catch {
            print("filePath 文件夹创建失败")
            return false
        }
    }

    static public func filesPathOfDirectory(path: String) -> [String] {
        do {
            let giftFilePathList = try FileManager.default.contentsOfDirectory(atPath: path)
            return giftFilePathList
        } catch {
            return [String]()
        }
    }
    
    static public func folderFeileSize(at folderPath: String) -> UInt64 {
        let manager = FileManager.default
        if FileManager.isFileExists(filePath: folderPath, isDirectory: true) == false {
            return 0
        }
        let childFilesEnumerator = manager.subpaths(atPath: folderPath)?.enumerated()
        var folderSize: UInt64 = 0
        for fileName in childFilesEnumerator! {
            let fileAbsolutePath = "\(folderPath)/\(fileName.element)"
            folderSize += self.sizeOfFile(at: fileAbsolutePath)
        }

        return folderSize
    }
    
    static public func folderFileSize(at folderPath: String, suffix: String) -> UInt64 {
        let manager = FileManager.default
        if FileManager.isFileExists(filePath: folderPath, isDirectory: true) == false {
            return 0
        }
        let childFilesEnumerator = manager.subpaths(atPath: folderPath)?.enumerated()
        var folderSize: UInt64 = 0
        for fileName in childFilesEnumerator! {
            if fileName.element.hasSuffix(suffix) {
                let fileAbsolutePath = "\(folderPath)/\(fileName.element)"
                folderSize += self.sizeOfFile(at: fileAbsolutePath)
            }
        }

        return folderSize
    }

    static public func forderFirstFilePath(at folderPath: String, suffix: String) -> String {
        if folderPath.count == 0 {
            return ""
        }
        let manager = FileManager.default
        if FileManager.isFileExists(filePath: folderPath, isDirectory: true) == false {
            return ""
        }
        let childFilesEnumerator = manager.subpaths(atPath: folderPath)?.enumerated()
        for fileName in childFilesEnumerator! {
            if fileName.element.hasSuffix(suffix) {
                let fileAbsolutePath = "\(folderPath)/\(fileName.element)"
                return fileAbsolutePath
            }
        }
        return ""
    }

    static public func sizeOfFile(at filePath: String) -> UInt64 {

        let manager = FileManager.default
        if FileManager.isFileExists(filePath: filePath, isDirectory: true) == false {
            return 0
        }
        let attr = try? manager.attributesOfItem(atPath: filePath)
        let size = attr?[FileAttributeKey.size] as? UInt64
        return size ?? 0
    }

    static public func sizeFormatterString(size: UInt64) -> String {
        if size == 0 {
            return ""
        }
        if size < 1024 {
            return "\(size)B"
        } else if size >= 1024 && size < (1024 * 1024) {
            return "\(size/1024)KB"
        } else if size >= (1024 * 1024) && size < (1024 * 1024 * 1024) {
            return "\(size/1024/1024)MB"
        } else {
            return "\(size/1024/1024/1024)GB"
        }
    }

}

extension FileManager {
    // 获取剩余空间大小
    static public func getSystemFreeSize() -> Double {
        /// 剩余大小
        var freesize = 0.0
       
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        do {
            let dictionary = try FileManager.default.attributesOfFileSystem(forPath: paths[paths.endIndex - 1])
            if let free = dictionary[.systemFreeSize] as? NSNumber {
                freesize = Double(free.doubleValue / 1024)
            }
        } catch {

        }
        return freesize/1024.0 // M
    }
}
