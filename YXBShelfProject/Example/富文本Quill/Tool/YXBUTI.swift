//
//  YXBUTI.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/2/7.
//


import Foundation
import ImageIO
import MobileCoreServices


// NOTE: MimeTypes - map of mimetype to file extension
// https://www.freeformatter.com/mime-types-list.html
private let mimeTypes = [
    "log": "text/plain",
    "html": "text/html",
    "htm": "text/html",
    "shtml": "text/html",
    "css": "text/css",
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "js": "application/javascript",
    "atom": "application/atom+xml",
    "rss": "application/rss+xml",
    "mml": "text/mathml",
    "txt": "text/plain",
    "jad": "text/vnd.sun.j2me.app-descriptor",
    "wml": "text/vnd.wap.wml",
    "htc": "text/x-component",
    "png": "image/png",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "wbmp": "image/vnd.wap.wbmp",
    "ico": "image/x-icon",
    "jng": "image/x-jng",
    "bmp": "image/x-ms-bmp",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "webp": "image/webp",
    "woff": "application/font-woff",
    "jar": "application/java-archive",
    "war": "application/java-archive",
    "ear": "application/java-archive",
    "json": "application/json",
    "hqx": "application/mac-binhex40",
    "doc": "application/msword",
    "pdf": "application/pdf",
    "ps": "application/postscript",
    "eps": "application/postscript",
    "ai": "application/postscript",
    "rtf": "application/rtf",
    "m3u8": "application/vnd.apple.mpegurl",
    "xls": "application/vnd.ms-excel",
    "eot": "application/vnd.ms-fontobject",
    "ppt": "application/vnd.ms-powerpoint",
    "wmlc": "application/vnd.wap.wmlc",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "7z": "application/x-7z-compressed",
    "cco": "application/x-cocoa",
    "jardiff": "application/x-java-archive-diff",
    "jnlp": "application/x-java-jnlp-file",
    "run": "application/x-makeself",
    "pl": "application/x-perl",
    "pm": "application/x-perl",
    "prc": "application/x-pilot",
    "pdb": "application/x-pilot",
    "rar": "application/x-rar-compressed",
    "rpm": "application/x-redhat-package-manager",
    "sea": "application/x-sea",
    "swf": "application/x-shockwave-flash",
    "sit": "application/x-stuffit",
    "tcl": "application/x-tcl",
    "tk": "application/x-tcl",
    "der": "application/x-x509-ca-cert",
    "pem": "application/x-x509-ca-cert",
    "crt": "application/x-x509-ca-cert",
    "xpi": "application/x-xpinstall",
    "xhtml": "application/xhtml+xml",
    "xspf": "application/xspf+xml",
    "zip": "application/zip",
    "epub": "application/epub+zip",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "kar": "audio/midi",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
    "m4a": "audio/x-m4a",
    "ra": "audio/x-realaudio",
    "3gpp": "video/3gpp",
    "3gp": "video/3gpp",
    "ts": "video/mp2t",
    "mp4": "video/mp4",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "mov": "video/quicktime",
    "webm": "video/webm",
    "flv": "video/x-flv",
    "m4v": "video/x-m4v",
    "mng": "video/x-mng",
    "asx": "video/x-ms-asf",
    "asf": "video/x-ms-asf",
    "wmv": "video/x-ms-wmv",
    "avi": "video/x-msvideo"
]

// We do not use the SwiftUTI pod anymore
// The library is embedded in MatrixKit. See Libs/SwiftUTI/README.md for more details
// import SwiftUTI

/// YXBUTI represents a Universal Type Identifier (e.g. kUTTypePNG).
/// See https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html#//apple_ref/doc/uid/TP40001319-CH202-SW5 for more information.
/// YXBUTI wraps UTI class from SwiftUTI library (https://github.com/mkeiser/SwiftUTI) to make it available for Objective-C.
@objcMembers
open class YXBUTI: NSObject, RawRepresentable {
    
    public typealias RawValue = String
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let utiWrapper: UTI
    
    // MARK: Public
    
    /// UTI string
    public var rawValue: String {
        return utiWrapper.rawValue
    }
    
    /// Return associated prefered file extension (e.g. "png").
    public var fileExtension: String? {
        return utiWrapper.fileExtension
    }
    
    /// Return associated prefered mime-type (e.g. "image/png").
    public var mimeType: String? {
        return utiWrapper.mimeType
    }
    
    // MARK: - Setup
    
    // MARK: Private
    
    private init(utiWrapper: UTI) {
        self.utiWrapper = utiWrapper
        super.init()
    }
    
    // MARK: Public
    
    /// Initialize with UTI String.
    /// Note: Although this initializer is marked as failable, due to RawRepresentable conformity, it cannot fail.
    ///
    /// - Parameter rawValue: UTI String (e.g. "public.png").
    public required init?(rawValue: String) {
        let utiWrapper = UTI(rawValue: rawValue)
        self.utiWrapper = utiWrapper
        super.init()
    }
    
    /// Initialize with UTI CFString.
    ///
    /// - Parameter cfRawValue: UTI CFString (e.g. kUTTypePNG).
    public convenience init?(cfRawValue: CFString) {
        self.init(rawValue: cfRawValue as String)
    }
    
    /// Initialize with file extension.
    ///
    /// - Parameter fileExtension: A file extesion (e.g. "png").
    public convenience init(fileExtension: String) {
        let utiWrapper = UTI(withExtension: fileExtension)
        self.init(utiWrapper: utiWrapper)
    }
    
    /// Initialize with MIME type.
    ///
    /// - Parameter mimeType: A MIME type (e.g. "image/png").
    public convenience init?(mimeType: String) {
        let utiWrapper = UTI(withMimeType: mimeType)
        self.init(utiWrapper: utiWrapper)
    }
    
    /// Check current UTI conformance with another UTI.
    ///
    /// - Parameter otherUTI: UTI which to conform with.
    /// - Returns: true if self conforms to other UTI.
    public func conforms(to otherUTI: YXBUTI) -> Bool {
        return self.utiWrapper.conforms(to: otherUTI.utiWrapper)
    }
    
    /// Check whether the current UTI conforms to any UTIs within an array.
    ///
    /// - Parameter otherUTIs: UTI which to conform with.
    /// - Returns: true if self conforms to any of the other UTIs.
    public func conformsToAny(of otherUTIs: [YXBUTI]) -> Bool {
        for uti in otherUTIs {
            if conforms(to: uti) {
                return true
            }
        }
        
        return false
    }
}

// MARK: - Other convenients initializers
extension YXBUTI {
    
    /// Initialize with image data.
    ///
    /// - Parameter imageData: Image data.
    convenience init?(imageData: Data) {
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
            let uti = CGImageSourceGetType(imageSource) else {
                return nil
        }
        self.init(rawValue: uti as String)
    }
    
    // swiftlint:disable unused_optional_binding
    
    /// Initialize with local file URL.
    /// This method is currently applicable only to URLs for file system resources.
    ///
    /// - Parameters:
    ///   - localFileURL: Local file URL.
    ///   - loadResourceValues: Indicate true to prefetch `typeIdentifierKey` URLResourceKey
    convenience init?(localFileURL: URL, loadResourceValues: Bool = true) {
        if loadResourceValues,
            let _ = try? FileManager.default.contentsOfDirectory(at: localFileURL.deletingLastPathComponent(), includingPropertiesForKeys: [.typeIdentifierKey], options: []),
            let uti = try? localFileURL.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier {
            self.init(rawValue: uti)
        } else if localFileURL.pathExtension.isEmpty == false {
            let fileExtension = localFileURL.pathExtension
            self.init(fileExtension: fileExtension)
        } else {
            return nil
        }
    }
    
    // swiftlint:enable unused_optional_binding
    
    public convenience init?(localFileURL: URL) {
        self.init(localFileURL: localFileURL, loadResourceValues: true)
    }
}

// MARK: - Convenients conformance UTIs methods
extension YXBUTI {
    public var isImage: Bool {
        return self.conforms(to: YXBUTI.image)
    }
    
    public var isVideo: Bool {
        return self.conforms(to: YXBUTI.movie)
    }
    
    public var isAudio: Bool {
        return self.conforms(to: YXBUTI.audio)
    }
    
    public var isFile: Bool {
        return self.conforms(to: YXBUTI.data)
    }
    
    // Office
    public var isWord: Bool {
        return matchFileType(as: ["doc", "docx"])
    }
    
    public var isEXCEL: Bool {
        return matchFileType(as: ["xls", "xlsx"])
    }
    
    public var isPPT: Bool {
        return matchFileType(as: ["ppt", "pptx"])
    }
    
    // PDF
    public var isPDF: Bool {
        return matchFileType(as: ["pdf"])
    }
    
    private func matchFileType(as fileTypes: [String]) -> Bool {
        if isFile {
            for fileType in fileTypes {
                //print(self.mimeType)
                //print(mimeTypes[fileType])
                if let mimetype = mimeTypes[fileType], mimetype == self.mimeType {
                    return true
                }
                continue
            }
        }
        return false
    }
}

// swiftlint:disable force_unwrapping

// MARK: - Some system defined UTIs
extension YXBUTI {
    public static let data = YXBUTI(cfRawValue: kUTTypeData)!
    public static let text = YXBUTI(cfRawValue: kUTTypeText)!
    public static let audio = YXBUTI(cfRawValue: kUTTypeAudio)!
    public static let video = YXBUTI(cfRawValue: kUTTypeVideo)!
    public static let movie = YXBUTI(cfRawValue: kUTTypeMovie)!
    public static let image = YXBUTI(cfRawValue: kUTTypeImage)!
    public static let png = YXBUTI(cfRawValue: kUTTypePNG)!
    public static let jpeg = YXBUTI(cfRawValue: kUTTypeJPEG)!
    public static let svg = YXBUTI(cfRawValue: kUTTypeScalableVectorGraphics)!
    public static let url = YXBUTI(cfRawValue: kUTTypeURL)!
    public static let fileUrl = YXBUTI(cfRawValue: kUTTypeFileURL)!
    public static let html = YXBUTI(cfRawValue: kUTTypeHTML)!
    public static let xml = YXBUTI(cfRawValue: kUTTypeXML)!
}

// swiftlint:enable force_unwrapping

// MARK: - Convenience static methods
extension YXBUTI {
    
    public static func mimeType(from fileExtension: String) -> String? {
        return YXBUTI(fileExtension: fileExtension).mimeType
    }
    
    public static func fileExtension(from mimeType: String) -> String? {
        return YXBUTI(mimeType: mimeType)?.fileExtension
    }
}
