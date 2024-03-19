//
//  RichEditorWebView.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/1/22.
//

import Foundation
import WebKit

class GNRichEditorWebView: WKWebView {

    var accessoryView: UIView?

    override var inputAccessoryView: UIView? {
        // remove/replace the default accessory view
        return accessoryView
    }

}
