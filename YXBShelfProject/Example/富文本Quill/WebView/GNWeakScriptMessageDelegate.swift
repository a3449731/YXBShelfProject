//
//  WeakScriptMessageDelegate.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/1/22.
//

import UIKit
import WebKit

class GNWeakScriptMessageDelegate: NSObject, WKScriptMessageHandler{
    weak var scriptDelegate: WKScriptMessageHandler?
    
    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)        
    }
    
    deinit {
        debugPrint("WeakScriptMessageDelegate is deinit")
    }
}
