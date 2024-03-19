//
//  PreviewViewController.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/1/22.
//

import UIKit
import WebKit


/**
 * @brief  预览富文本的类
 */
@objcMembers
class GroupNoticePreviewViewController: GroupNoticeBaseViewController {
    
    override init(with room: YXBRoom, canEdit: Bool) {
        super.init(with: room, canEdit: canEdit)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func eiditAction() {
        let vc = GroupNoticeViewController(with: self.myRoom)
        vc.announcementDic = announcementDic
        vc.htmlContent = lastedHtmlContent
//        vc.loadViewIfNeeded()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // WKNavigationDelegate
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        
        // Disable webview long press to pop up menuControl
        self.webView.evaluateJavaScript(
            "document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        self.webView.evaluateJavaScript(
            "document.documentElement.style.webkitUserSelect='none';",
            completionHandler: nil)
    }
}
