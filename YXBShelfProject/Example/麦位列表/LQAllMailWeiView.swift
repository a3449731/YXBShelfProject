//
//  LQAllMailWeiView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa

@objcMembers class LQAllMailWeiView: UIView {
    
    // 由外界传入,房间的类型。初始化方法中创建
    var roomType: LQRoomType!
    //  房间的信息，5人房的房主信息需要从里面拼出来,外面是一坨屎，不想写模型了
    var roomInfo: [String: Any]? {
        didSet {
            // 这是为了5人房准备的, 因为5人房的数据是根据房间信息里的几个字段来的
            if roomInfo != nil && roomType == .merchant_5 {
                let model = self.viewModel.host_vm.value
                model.uname = roomInfo?["hname"] as? String
                model.meiNum = roomInfo?["meiNum"] as? String
                model.id = roomInfo?["huid"] as? String
                model.headKuang = roomInfo?["headKuang"] as? String
                model.uimg = roomInfo?["himg"] as? String
                if let isb = (roomInfo?["isb"] as? String)?.bool {
                    model.isb = isb
                }
                if let status = roomInfo?["userStatus"] as? [String: Any] {
                    if let isFz = (status["isFz"] as? String)?.bool {
                        model.isFz = isFz
                    }
                    if let isAdmin = (status["isAdmin"] as? String)?.bool {
                        model.isAdmin = isAdmin
                    }
                }
                self.viewModel.host_vm.accept(model)
            }
        }
    }
    
    let disposed = DisposeBag()
    let viewModel: LQMaiWeiViewModel = LQMaiWeiViewModel()
    
    // 房主麦位,直接借用cell，懒得再写赋值代码了
    @objc var hostUserView: LQMaiWeiCell = {
        let contentView = LQMaiWeiCell()
        contentView.backgroundColor = .cyan
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    // 其他人麦位
    @objc lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.fitScale()
        layout.minimumInteritemSpacing = 5.fitScale()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15.fitScale(), bottom: 0, right: 15.fitScale())
        layout.itemSize = CGSize(width: 78.fitScale(), height: 95.fitScale())
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellWithClass: LQMaiWeiCell.self)
        return collectionView
    }()
    
    
    // 不可用的初始化方法
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) is not available. Use init(roomType:) instead.")
    }
    
    // 必须通过这个方法去初始化
    init(roomType: String) {
        super.init(frame: .zero)
        guard let type = LQRoomType(rawValue: roomType) else {
            debugPrint("xxxxx 房间类型错误 xxxxxxx")
            return
        }
        self.roomType = type
        
        self.setupUI()
        self.setupTool()
        self.setupData()
    }
    
    private func setupUI() {
        self.addSubview(hostUserView)
        hostUserView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.fitScale())
            make.centerX.equalToSuperview()
            make.width.equalTo(60.fitScale())
            make.height.equalTo(95.fitScale())
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(hostUserView.snp.bottom).offset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo((190 + 5).fitScale())
        }
    }
    
    private func setupTool() {
        self.rx_HostView()
        self.rx_ColletionView()
    }
    
    private func setupData() {
        let hostModel = self.viewModel.creatHostMaiWei(roomType: self.roomType)
        self.viewModel.host_vm.accept(hostModel)
        
        var count = (self.roomType == .merchant_5 ? 4 : 8)
        let tempArray = self.viewModel.creatMaiWei(count: count, roomType: self.roomType)
        self.viewModel.modelArray_vm.accept(tempArray)
    }
    
    // 主持麦位
    private func rx_HostView() {
        viewModel.host_vm
            .subscribe(onNext: { [weak self] model in
                self?.hostUserView.setup(model: model)
            })
            .disposed(by: disposed)        
    }
    
    private func rx_ColletionView() {
        // MARK: collectionView数据源
        viewModel.modelArray_vm
            .bind(to: collectionView.rx.items(cellIdentifier: "LQMaiWeiCell", cellType: LQMaiWeiCell.self)) { [weak self] index, model, cell in
//                debugPrint("刷新了第\(index)cell")
                cell.backgroundColor = .cyan
                cell.setup(model: model)
//                cell.model = model
            }
            .disposed(by: disposed)
        
        // MARK: collectionView点击事件
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
            })
            .disposed(by: disposed)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }

}

extension LQAllMailWeiView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        collectionView.dequeueReusableCell(withClass: LQMaiWeiCell.self, for: indexPath)
//    }
        
}

#Preview {
    let contentView = UIView()
    contentView.backgroundColor = .gray
    let allView = LQAllMailWeiView(roomType: "1")
    allView.frame = CGRectMake(0, 0, ScreenConst.width, 220.fitScale())
    contentView.addSubview(allView)
    
    return contentView    
}

