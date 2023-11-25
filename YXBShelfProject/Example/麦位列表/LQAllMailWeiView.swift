//
//  LQAllMailWeiView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class LQAllMailWeiView: UIView {
    
    let disposed = DisposeBag()
    let viewModel: LQMaiWeiViewModel = LQMaiWeiViewModel()
    
    // 房主麦位
    let hostUserView: LQMaiWeiView = {
        let contentView = LQMaiWeiView()
        contentView.backgroundColor = .cyan
        contentView.userView.headerView.setImage(url: "https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1690792476235.jpg", headerFrameUrl: "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241627225.webp", placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
        contentView.hStack.backgroundColor = .black
        contentView.titleLabel.text = "Ss.草电风扇申达股份."
        contentView.sortLabel.text = "4"
        contentView.identityImageView.image = UIImage(named: "CUYuYinFang_fanzhuHead")
        contentView.charmButton.setTitle("1000w", for: .normal)
        return contentView
    }()
    
    // 其他人麦位
    @objc lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.fitScale()
        layout.minimumInteritemSpacing = 10.fitScale()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15.fitScale(), bottom: 0, right: 15.fitScale())
        layout.itemSize = CGSize(width: 78.fitScale(), height: 100.fitScale())
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellWithClass: LQMaiWeiCell.self)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupTool()
        self.setupData()
    }
    
    private func setupUI() {
        self.addSubview(hostUserView)
        hostUserView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(60.fitScale())
            make.height.equalTo(100.fitScale())
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(hostUserView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(210.fitScale())
        }
    }
    
    private func setupTool() {
        self.rx_ColletionView()
    }
    
    private func setupData() {

        self.viewModel.creatMaiWei(count: 8)
        
        self.viewModel.requestMainWeiList(houseId: "26663258") {
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.viewModel.modelArray_vm.value[2].isSpeaking = true
        }
    }
    
    
    
    private func rx_ColletionView() {
        // MARK: collectionView数据源
        viewModel.modelArray_vm
            .bind(to: collectionView.rx.items(cellIdentifier: "LQMaiWeiCell", cellType: LQMaiWeiCell.self)) { [weak self] index, model, cell in
                debugPrint("刷新了第\(index)cell")
                cell.backgroundColor = .cyan
                cell.setup(model: model)
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
    let allView = LQAllMailWeiView()
    allView.frame = CGRectMake(0, 0, ScreenConst.width, 220.fitScale())
    contentView.addSubview(allView)
    
    return contentView
    
//    LQMaiWeiViewController()
}

