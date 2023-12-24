//
//  DialogViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/12/23.
//

import UIKit
import SwiftMessages
import RxSwift
import RxCocoa

class DialogViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let btn1 = MyUIFactory.commonButton(title: "SwiftMessages内置的其中一种样式", titleColor: .titleColor_black, titleFont: nil, image: nil)
            
    let btn2 = MyUIFactory.commonButton(title: "纯代码自定义的view", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    let btn3 = MyUIFactory.commonButton(title: "中心弹出,可拖动消息", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    let btn4 = MyUIFactory.commonButton(title: "弹出的是控制器", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    let btn5 = MyUIFactory.commonButton(title: "弹出的还是控制器", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SwiftMessages.defaultConfig.presentationStyle = .bottom
        view.addSubviews([btn1, btn2, btn3, btn4, btn5])
        
        btn1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        btn2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        btn3.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.centerX.equalToSuperview()
        }
        
        btn4.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(400)
            make.centerX.equalToSuperview()
        }
        
        btn5.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(500)
            make.centerX.equalToSuperview()
        }
        
        btn1.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showImageDialog()
            })
            .disposed(by: disposeBag)
        
        
        btn2.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.demoAnyView()
            })
            .disposed(by: disposeBag)
        
        btn3.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.demoCentered()
            })
            .disposed(by: disposeBag)
        
        btn4.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showCustomViewController()
            })
            .disposed(by: disposeBag)
        
        btn5.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showcustomViewController2()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Popup Dialog examples

    /*!
     Displays the default dialog with an image on top
     */
    func showImageDialog(animated: Bool = true) {
        // .cardView是有SwiftMessages提供的几种样式之一
        let view = MessageView.viewFromNib(layout: .cardView)
//        let view = UIView()
        view.backgroundColor = .red
        view.frame = CGRectMake(0, 0, 300, 100)
        SwiftMessages.show(view: view)
    }


    // 可以自定义任意view。 demo中大部分示例是继承自MessageView。并且用xib创建的界面,比较快。
    func demoAnyView() -> Void {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lq_pk_bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        let messageView = BaseView(frame: .zero)
        messageView.layoutMargins = .zero
        messageView.backgroundHeight = 120.0
        do {
            let backgroundView = CornerRoundingView()
            backgroundView.cornerRadius = 15
            backgroundView.layer.masksToBounds = true
            messageView.installBackgroundView(backgroundView)
            messageView.installContentView(view)
            messageView.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        messageView.configureDropShadow()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    
    // 中心弹出
    func demoCentered() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Hey There!", body: "Please try swiping to dismiss this message.", iconImage: nil, iconText: "🦄", buttonImage: nil, buttonTitle: "No Thanks") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    // 弹出控制器
    func showCustomViewController() {
        let customViewController = TestDialogViewController()
        let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: customViewController)
        // 弹出的方式，选择从底部
        segue.presentationStyle = .bottom
        // 弹出的背景模型 interactive:表示能点击背景消失。
        segue.dimMode = .gray(interactive: true)
        
        // 边距，需要配合 containment = .background 一起使用才生效
        // 这个会空出安全区
        /*
        segue.messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
        segue.containment = .background
        */
        // 从最底部开始，无视安全区
        segue.messageView.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segue.containment = .backgroundVertical
                
        // 折叠侵入非零安全区域内嵌的布局边距边缘。
        segue.messageView.collapseLayoutMarginAdditions = true
                
        // 添加默认阴影
        segue.messageView.configureDropShadow()
                
        // Change the corner radius
        segue.containerView.cornerRadius = 20
        
        // 该类KeyboardTrackingView可用于在键盘距离太近时使消息视图通过向上滑动来避开键盘。
        segue.keyboardTrackingView = KeyboardTrackingView()
        
        // 设置高度
        segue.messageView.backgroundHeight = 600
        
        // 弹出
        segue.perform()
        
        customViewController.didTaoHelloClosure = {
            debugPrint("点击了你好")
        }
    }
    
    // 弹出控制器
    func showcustomViewController2() {
        let customViewController = TestDialogViewController()
        let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: customViewController)
        // 弹出的方式，选择从底部
        segue.presentationStyle = .bottom
        // 弹出的背景模型 interactive:表示能点击背景消失。
        segue.dimMode = .gray(interactive: true)
        
        // 边距，需要配合 containment = .background 一起使用才生效
        // 这个会空出安全区
        segue.messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
        segue.containment = .background

        segue.perform()
        
        customViewController.didTaoHelloClosure = {
            debugPrint("点击了你好")
        }
    }
    
}

#Preview {
    DialogViewController()
}
