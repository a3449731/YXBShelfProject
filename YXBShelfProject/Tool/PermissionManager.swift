//
//  PermissionManager.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit
import Photos

extension PermissionManager {
    enum PrivacyType: String {
        /// 相机权限
        case camera = "相机"
        /// 麦克风权限
        case microphone = "麦克风"
        ///  访问相册
        case photoLibrary  = "照片"
     
        
        var alertTitle: String {
            switch self {
            case .camera:  return "无法访问相机"
            case .microphone:  return "无法访问麦克风"
            case .photoLibrary:  return "无法访问相册"
            }
        }
    }
}


//授权成功的回调
typealias PermissionSuccessBlock = () -> Void

class PermissionManager {
    
    
    static func openSystemSettings() {
        if  let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /// 申请相册使用权限
    /// - Parameter handler: 授权成功才回调
    static func requestPhotoLibrary(_ handler: @escaping PermissionSuccessBlock) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            handler()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized {
                    DispatchQueue.main.async {
                          handler()
                    }
                }
            }
        } else {
            showPermissionAlert(.photoLibrary)
        }
    }
    
    
    static func requestVideo(_ handler: @escaping PermissionSuccessBlock)  {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            handler()
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        handler()
                    }
                }
            }
           
        } else {
            showPermissionAlert(.camera)
        }
    }
    
    static func requestAudio(_ handler: @escaping PermissionSuccessBlock)  {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        if status == .authorized {
            handler()
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                if granted {
                     DispatchQueue.main.async {
                         handler()
                     }
                }
            }
        } else {
            showPermissionAlert(.microphone)
        }
    }
    
    
    static func showPermissionAlert(_ type: PrivacyType) {
        let alertController = UIAlertController(title: type.alertTitle, message: "请在iPhone的\"设置-隐私-\(type.rawValue)\"中开启权限", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        ScreenConst.getCurrentUIController()?.present(alertController, animated: true)        
    }
}
