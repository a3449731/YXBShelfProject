//
//  DownloadViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit
import RxSwift
import RxCocoa
import Tiercel


// 初始化下载管理类，有个bug，我现在还没玩明白，好像是同名初始化多次就会有问题，我看demo这个管理是放在Appdelegate中全局持有的。
let yxbSessionManager1 = SessionManager("ViewController1", configuration: SessionConfiguration())

// 资源下载库， 更多的使用参考源码: https://github.com/Danie1s/Tiercel
class DownloadViewController: UIViewController {
    
    let disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = MyUIFactory.commonButton(title: "点我下载视频", titleColor: .black, titleFont: UIFont.systemFont(ofSize: 16), image: nil)
        btn.frame = CGRectMake(100, 200, 150, 50)
        view.addSubview(btn)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.downLoad()
        }).disposed(by: disposed)
        
        
    }
    
    
    private func downLoad() {
        yxbSessionManager1.download("https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1698742646871.mp4")?.progress { [weak self] (task) in
            let progress = task.progress.fractionCompleted
            debugPrint("下载中, 进度：\(progress)")
        }.completion { [weak self] task in
            if task.status == .succeeded {
                // 下载成功
                debugPrint("下载完成")
            } else {
                // 其他状态
                debugPrint("下载失败")
            }
        }.validateFile(code: "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1698742646871.mp4".md5, type: .md5) { [weak self] (task) in
            if task.validation == .correct {
                // 文件正确
                debugPrint("文件正确")
            } else {
                // 文件错误
                debugPrint("文件错误")
            }
        }
    }
}
