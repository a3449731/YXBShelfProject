//
//  MessageViewController.swift
//  YXBSwiftProject
//
//  Created by yangxiaobin on 2023/11/8.
//  Copyright © 2023 ShengChang. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        let tableView = RoomMessageTableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.left.equalToSuperview()
            make.bottom.equalTo(-100)
            make.right.equalToSuperview()
        }
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}
