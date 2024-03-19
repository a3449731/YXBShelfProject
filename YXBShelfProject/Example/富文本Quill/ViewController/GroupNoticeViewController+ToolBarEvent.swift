//
//  GroupNoticeViewController+ToolBarEvent.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/2/7.
//

import Foundation
import WebKit
import SnapKit
import Photos

// MARK: - toolBar
extension GroupNoticeViewController: GNEditToolBarDelegate {
    func focus() {
        webView.evaluateJavaScript("focus()") { (val, err) in
            debugPrint("val: \(String(describing: val)), err: \(String(describing: err))")
        }
    }
    
    func blur(_ toolBar: GNEditToolBar) {
        webView.evaluateJavaScript("blur()") { [weak self] (val, err) in
            self?.view.endEditing(true)
            debugPrint("val: \(String(describing: val)), err: \(String(describing: err))")
        }
        
        // fix ios 16.5 below
        var toolBarY = self.view.frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.editToolBar.frame = CGRect(x: 0, y: toolBarY, width: self.width, height: self.toolBarHeight)
            // fix menuView animate
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }) { (complete) in
        }
    }
    
    func editToolBar(_ toolBar: GNEditToolBar, action: String, val: Any?) {
        debugPrint("action: \(action)")
        switch action {
        case "br":
            let selected = val as! Bool
//            "setList('\(result)')"
            webView.evaluateJavaScript("setBr('\(selected)')", completionHandler: nil)
            break
            
        case "blod":
            let selected = val as! Bool
            webView.evaluateJavaScript("setBold(\(selected))", completionHandler: nil)
            break
            
        case "italic":
            let selected = val as! Bool
            webView.evaluateJavaScript("setItalic(\(selected))", completionHandler: nil)
            break
            
        case "underline":
            let selected = val as! Bool
            webView.evaluateJavaScript("setUnderline(\(selected))", completionHandler: nil)
            break
            
        case "strike":
            let selected = val as! Bool
            webView.evaluateJavaScript("setStrike(\(selected))", completionHandler: nil)
            break
            
        case "indent-increase":
            webView.evaluateJavaScript("setIndent('+1')", completionHandler: nil)
            break
            
        case "indent-decrease":
            webView.evaluateJavaScript("setIndent('-1')", completionHandler: nil)
            break
            
        case "header":
            var result: Any
            if let selected = val as? Bool, selected {
                result = 2
            }else{
                result = false
            }
            webView.evaluateJavaScript("setHeader(\(result))", completionHandler: nil)
            break
            
        case "center", "right":
            var result: Any
            if let selected = val as? Bool, selected {
                result = action
                webView.evaluateJavaScript("setAlign('\(result)')", completionHandler: nil)
            }else{
                result = false
                webView.evaluateJavaScript("setAlign(\(result))", completionHandler: nil)
            }
            break
            
        case "left":
            webView.evaluateJavaScript("setAlign(\(false))", completionHandler: nil)
            break
            
        case "bullet", "ordered":
            var result: Any
            if let selected = val as? Bool, selected {
                result = action
                webView.evaluateJavaScript("setList('\(result)')", completionHandler: nil)
            }else{
                result = false
                webView.evaluateJavaScript("setList(\(result))", completionHandler: nil)
            }
            break
            
        case "undo":
            webView.evaluateJavaScript("undo()", completionHandler: nil)
            break
            
        case "redo":
            webView.evaluateJavaScript("redo()", completionHandler: nil)
            break
            
        case "image":
//            showPickImageVC()
            self.moreBtnClick = !self.moreBtnClick
            
            if self.moreBtnClick {
                self.view.endEditing(true)
            } else {
                self.focus()
            }
            break
            
        case "color":
            isFontColor = true
//            showColorPickVC()
            break
            
        case "background":
            isFontColor = false
//            showColorPickVC()
            break
            
        case "sub", "super":
            var result: Any
            if let selected = val as? Bool, selected {
                result = action
                webView.evaluateJavaScript("setScript('\(result)')", completionHandler: nil)
            }else{
                result = false
                webView.evaluateJavaScript("setScript(\(result))", completionHandler: nil)
            }
            break
            
        case "size":
            var result: Any
            if let selected = val as? Bool, selected {
                // small normal large huge
                result = "large"
                webView.evaluateJavaScript("setSize('\(result)')", completionHandler: nil)
            }else{
                result = false
                webView.evaluateJavaScript("setSize(\(result))", completionHandler: nil)
            }
            break
            
        case "code-block":
            var result: Any
            if let selected = val as? Bool, selected {
                result = 1
            }else{
                result = false
            }
            webView.evaluateJavaScript("setCodeblock(\(result))", completionHandler: nil)
            break
            
        case "blockquote":
            var result: Any
            if let selected = val as? Bool, selected {
                result = 1
            }else{
                result = false
            }
            webView.evaluateJavaScript("setBlockquote(\(result))", completionHandler: nil)
            break
            
        case "format-clear":
            webView.evaluateJavaScript("removeAllFormat()", completionHandler: nil)
            break
        default: break
        }
    }
    
    func editFontColor() {
        if isFontColor {
            webView.evaluateJavaScript("setColor('\(colorHex)')", completionHandler: nil)
        }else{
            webView.evaluateJavaScript("setBackgroundColor('\(backgroundColorHex)')", completionHandler: nil)
        }
    }
    
    func insertImage(_ image: UIImage){
        // 1.上传图片，获得图片地址
        // 2.链接插入到webview
        self.view.makeToast("请完成上传图片")
        /*
        // Retrieve the current picture and make sure its orientation is up
        guard let updatedPicture = YXBTools.forceImageOrientationUp(image) else { return }
        
        // Upload picture
        let uploader = MXMediaManager.prepareUploader(withMatrixSession: self.mxRoom.mxSession, initialRange: 0, andRange: 1.0)
        
        uploader?.uploadData(updatedPicture.jpegData(compressionQuality: 0.5), filename: nil, mimeType: "image/jpeg", expired: 0, success: {[weak self] url in
            guard let self = self else { return }
            guard let urlString = url else { return }
            self.webView.evaluateJavaScript("insertImage('\(urlString)')", completionHandler: nil)
            self.focus()
            
        }, failure: {[weak self] error  in
            guard let self = self else { return }
            guard let error = error else { return }
        })
        */
    }
}

// MARK: - More operater
extension GroupNoticeViewController: GNMenuViewDelegate {
    func menuView(_ menu: GNMenuView, didSelect item: GNMenuItemType) {
        switch item {
        case .picture: self.showMediaPicker()
        case .takePhoto: self.takePhoto()
        case .file: self.chooseFile()
        }
    }
}

// MARK: - CameraPresenterDelegate, ZLPhotoBrwoser
extension GroupNoticeViewController {
    // ZLPhotoBrwoser
    func showMediaPicker() {
        // 1.选择图片，
        // 2.去上传插入图片，并插入到quill富文本
        self.view.makeToast("请自行实现图片选择")
        /*
        let cfg = ZLPhotoConfiguration.default()
        cfg.allowSelectOriginal = false
        cfg.allowTakePhotoInLibrary = false
        cfg.sortAscending = false
        cfg.columnCount = 3
        cfg.maxSelectCount = 1
        
        let ac = ZLPhotoPreviewSheet(results: nil)
        ac.selectImageBlock = {[weak self](results: [ZLResultModel], isOrigin: Bool) in
            if let assert = results.first?.asset, let self = self {
                let options = PHImageRequestOptions()
                options.isSynchronous = false
                options.isNetworkAccessAllowed = true
                PHImageManager.default().requestImageDataAndOrientation(for: assert, options: options) {[weak self](data, dataUTI, orientation, info) in
                    guard let self = self else { return }
                    guard let imageData = data else { return }
                    guard let uti = dataUTI as CFString? else { return }
                    guard let selectedImage = UIImage(data: imageData) else { return }
                    self.insertImage(selectedImage)
                }
                
            }
        }
        ac.showPhotoLibrary(sender: self)
        */
    }
    
    /*
    func cameraPresenter(_ presenter: CameraPresenter, didSelectImage image: UIImage) {
        presenter.dismiss(animated: true, completion: nil)
        // Retrieve the current picture and make sure its orientation is up
//        guard let updatedPicture = YXBTools.forceImageOrientationUp(image) else { return }
        self.insertImage(image)
    }
    
    func cameraPresenter(_ presenter: CameraPresenter, didSelectVideoAt url: URL) {
        presenter.dismiss(animated: true, completion: nil)
    }
    
    func cameraPresenterDidCancel(_ presenter: CameraPresenter) {
        presenter.dismiss(animated: true, completion: nil)
    }
    */

    /// Present a camera view to take a photo to use for the avatar.
    private func takePhoto() {
        self.view.makeToast("请自行实现拍照逻辑")
        /*
        cameraPresenter.presentCamera(from: self, with: [.image], animated: true)
         */
    }
}

// MARK: - File 文件选择器
extension GroupNoticeViewController: YXBDocumentPickerPresenterDelegate {
    private func chooseFile() {
        let documentPickerPresenter = YXBDocumentPickerPresenter()
        documentPickerPresenter.delegate = self
        let allowedUTIs = [YXBUTI.data]
        documentPickerPresenter.presentDocumentPicker(with: allowedUTIs, from: self, animated: true) {
            
        }
        self.documentPickerPresenter = documentPickerPresenter
    }
    
    func documentPickerPresenter(_ presenter: YXBDocumentPickerPresenter, didPickDocumentsAt url: URL) {
        self.documentPickerPresenter = nil;
        
        guard let fileUTI = YXBUTI(localFileURL: url) else { return }
        let mimeType = fileUTI.mimeType
        
        if fileUTI.isImage {
            self.uploadFile(url: url, mimeType: mimeType ?? nil, complete: nil)
        } else if fileUTI.isVideo {
            self.uploadFile(url: url, mimeType: mimeType ?? nil, complete: nil)
        } else if fileUTI.isFile {
            if let mimeType = mimeType, mimeType.count > 0 {
                self.uploadFile(url: url, mimeType: mimeType, complete: nil)
            } else {
                let alertController = UIAlertController(title: "文件", message: "文件类型不支持", preferredStyle: .alert)
                alertController.overrideUserInterfaceStyle = .dark;
                let action = UIAlertAction(title: "确认", style: .default) { action in
                    
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                return;
            }
        } else {
            debugPrint("[GroupNoticeViewController] File upload using MIME type %@ is not supported.", mimeType)
            self.showAlert(title: "文件上传错误", message: "文件类型不支持")
        }
    }
    
    func documentPickerPresenterWasCancelled(_ presenter: YXBDocumentPickerPresenter) {
        self.documentPickerPresenter = nil
    }
    
    private func showAlert(title: String, message: String) -> UIAlertController {
//        return [[AppDelegate theDelegate] showAlertWithTitle:title message:message];
        return UIAlertController()
    }
    
    private func uploadFile(url: URL, mimeType: String?, complete:(() -> Void)?) {
        self.view.makeToast("请自行文件上传逻辑")
        /*
        let fileName = url.lastPathComponent
                
        let uploader = MXMediaManager.prepareUploader(withMatrixSession: self.mxRoom.mxSession, initialRange: 0, andRange: 1.0)
        uploader?.uploadFilePath(url.path, filename: fileName, mimeType: mimeType, expired: 1, encryptInfo: nil, success: {[weak self] httpUrl in
            guard let self = self else { return }
            guard let urlString = httpUrl else { return }
            
            let model = GroupNoticeFileModel()
            model.type = mimeType
            model.file_url = urlString
            model.file_name = fileName
            model.file_size = (NetworkFileManager.sharedManager() as? NetworkFileManager)?.getFileSize(url.path)
            self.fileList.append(model)
            self.tableView.reloadData()
            
            self.blur(self.editToolBar)
            
        }, failure: {[weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
        })
        */
    }
}
