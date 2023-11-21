//
//  BrowswerViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class BrowswerViewController: UIViewController {
    
    let disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = MyUIFactory.commonButton(title: "点我预览图片", titleColor: .black, titleFont: UIFont.systemFont(ofSize: 16), image: nil)
        btn.frame = CGRectMake(100, 200, 150, 50)
        view.addSubview(btn)
                
        btn.rx.tap.subscribe(onNext: { [weak self] in
            let array = ["https://t7.baidu.com/it/u=91673060,7145840&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=1297102096,3476971300&fm=193&f=GIF"]
            YXBPhotoBrowswer.show(urlArray: array, currentIndex: 1)
        }).disposed(by: disposed)
    }
    
    
}
