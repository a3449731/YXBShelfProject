//
//  QuillViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2024/3/19.
//

import UIKit
import SwiftyJSON

class QuillViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .backgroundColor_gray
        
        var button = UIButton(type: .custom)
        button.frame = CGRectMake(100, 300, 200, 100)
        button.setTitleColor(.red, for: .normal)
        button.setTitle("点我跳富文本", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(jumpAction), for: .touchUpInside)
        
    }
    
    
    //    (lldb) po tappedEvent.wireContent[@"announcement"]
    
    
    @objc func jumpAction() {
        let htmlContent = """
<ol><li>小信息asf</li><li>但是上课</li><li>啊孙菲菲</li></ol><p>是飒飒飒</p><ul><li>萨阿迪</li><li>的说法</li><li>阿斯蒂芬a</li><li>阿是</li></ul><p>啊沙发沙发发阿萨法</p><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><p>阿萨斯阿凡达啊</p><p><br></p><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><p>艾弗森啊谁发的</p><p><br></p><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><p><br></p><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><p>一直没时间给她</p><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><p>买吃喝的零食</p><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><ul><li>啊哈笑的肚子饿</li></ul><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><ul><li>吃饱饭才</li></ul><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><ul><li>吃了半</li></ul><hr style=\"border: 1px solid #eee; margin: 12px 0;\"><ul><li>根雪糕🍧……</li></ul><p><br></p><p><br></p>
"""
        
        let filesDict: [String: Any] = [
            "content": htmlContent,
            "file_list": [
                [
                    "file_url": "https://hs.sending.me/_file-service/download?id=f56c2a08-a19c-4ff3-98c4-112a4a7f9770",
                    "id": "f56c2a08-a19c-4ff3-98c4-112a4a7f9770",
                    "file_name": "e1716a4b-b37d-4015-9cfc-c55e23a65d0c.png",
                    "type": "png",
                    "file_size": 113752,
                ],
                [
                    "file_url": "https://hs.sending.me/_file-service/download?id=efd271e2-6a18-45c5-8507-24d04afede97",
                    "id": "efd271e2-6a18-45c5-8507-24d04afede97",
                    "file_name": "README.md",
                    "type": "md",
                    "file_size": 13603,
                ],
                [
                    "file_url": "https://hs.sending.me/_file-service/download?id=5288b7cc-0cf4-4bf7-86c1-7c9c1bda2190",
                    "id": "5288b7cc-0cf4-4bf7-86c1-7c9c1bda2190",
                    "file_name": "AlphaWallet-min.js",
                    "type": "js",
                    "file_size": 719638,
                ]
            ],
            "sourceRoomId": "!YvzlsLxtE0CNsMwN-@sdn_e33b0db7741d6d18262222e1cf372d1258833191:e33b0db7741d6d18262222e1cf372d1258833191",
        ]
        
        
        let vc = GroupNoticePreviewViewController(with: YXBRoom(), canEdit: true)
//        vc.lastedHtmlContent = "<p>我就是最新的内容</[>"
        vc.lastedHtmlContent = htmlContent
        vc.announcementDic = filesDict
//        vc.loadViewIfNeeded()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

