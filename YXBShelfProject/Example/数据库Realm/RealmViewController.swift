//
//  RealmViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/12/26.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

// 官方链接: https://github.com/realm/realm-swift
class RealmViewController: UIViewController {
        
    let disposeBag = DisposeBag()
    
    // 链接数据库
    let realm = try! Realm()
//    let array = try! Realm().objects(RealDog.self)
    var notificationToken: NotificationToken?
    
    // 容器
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30
        return stackView
    }()
    
    let btn1 = MyUIFactory.commonButton(title: "链接数据库", titleColor: .titleColor_black, titleFont: nil, image: nil)
            
    let btn2 = MyUIFactory.commonButton(title: "添加", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    let btn3 = MyUIFactory.commonButton(title: "删除", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    let btn4 = MyUIFactory.commonButton(title: "修改", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    let btn5 = MyUIFactory.commonButton(title: "查询", titleColor: .titleColor_black, titleFont: nil, image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(hStack)
        hStack.addArrangedSubviews([btn1, btn2, btn3, btn4, btn5])
        
        hStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.bottom.equalToSuperview().inset(200)
            make.left.right.equalToSuperview()
        }
        
        btn1.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openDB()
            })
            .disposed(by: disposeBag)
        
        
        btn2.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.addItem()
            })
            .disposed(by: disposeBag)
        
        btn3.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deleteItem()
            })
            .disposed(by: disposeBag)
        
        btn4.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.updateItem()
            })
            .disposed(by: disposeBag)
        
        btn5.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.findItems()
            })
            .disposed(by: disposeBag)
                        
        
        let array = realm.objects(ReamlModel.self)
        log.debug(array)
        // Retain notificationToken as long as you want to observe
        self.notificationToken = array.observe { (changes) in
            switch changes {
            case .initial: break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    // 链接
    func openDB() {
        // 控制器初始化的时候已经链接过了
        
        let array = realm.objects(RealDog.self)
        log.debug(array)
    }
    
    // 添加
    func addItem() {
        // Use them like regular Swift objects
        let model = ReamlModel()
        model.name = "Rex"
        model.age = 1
        model._id = UUID().uuidString
        
        let dog = RealDog()
        dog.name = "旺财"
        dog.age = 20
        
        model.dogs.append(dog)
                        
        // Persist your data easily with a write transaction
        try! realm.write {
            realm.add(model)
        }
        
        let array = realm.objects(ReamlModel.self)
        log.debug(array)
    }
    
    // 删
    func deleteItem() {
        
        let modelArray = realm.objects(ReamlModel.self).filter { model in
            model.name == "Rex"
        }
        
        try! realm.write {
            realm.delete(modelArray)
        }
        
        let array = realm.objects(ReamlModel.self)
        log.debug(array)
    }
    
    // 改
    func updateItem() {
        
        // 可以通过主键，查唯一元素。
        var model = realm.object(ofType: ReamlModel.self, forPrimaryKey:
        "D32622FC-B700-4846-8003-1356E1E02637")
        
        try! realm.write {
            model?.name = "张三"
        }
        
        let array = realm.objects(ReamlModel.self)
        log.debug(array)
    }
    
    // 查
    func findItems() {
        
        let array = realm.objects(ReamlModel.self).filter { model in
            model.age > 0
        }
        log.debug(array)
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}

#Preview {
    RealmViewController()
}
