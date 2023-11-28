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
    
    // 房主麦位,直接借用cell，懒得再写赋值代码了
    var hostUserView: LQMaiWeiCell = {
        let contentView = LQMaiWeiCell()
//        contentView.backgroundColor = .cyan
//        contentView.userView.headerView.setImage(url: "https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1690792476235.jpg", headerFrameUrl: "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241627225.webp", placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
//        contentView.hStack.backgroundColor = .black
//        contentView.titleLabel.text = "Ss.草电风扇申达股份."
//        contentView.sortLabel.text = "4"
//        contentView.identityImageView.image = UIImage(named: "CUYuYinFang_fanzhuHead")
//        contentView.charmButton.setTitle("1000w", for: .normal)
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
        self.rx_HostView()
        self.rx_ColletionView()
    }
    
    private func setupData() {

        let tempArray = self.viewModel.creatMaiWei(count: 8)
        self.viewModel.modelArray_vm.accept(tempArray)
        

        let tempstring = """
        {"biList":["1"],"suoList":["3"],"maiweiNameList":[{"name":"不是说我","id":"a7e79ab70e914d8c820df6fa669ff172","maino":"4"}],"dataList":[{"uname":"张四","caiLevel":29,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"1","vipInfo":{},"mai":"0","meiNum":"4752","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/head_img/20230929-031959.jpg","isb":"1","id":"e8394b2c4c2d489fa41b62922546077d","maiNo":"0","nianl":28,"meiliNum":"4752"},{"uname":"哈欠不断扩大用户收入囊中","caiLevel":101,"isJy":"0","jueName":"","isAdmin":"0","headKuang":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241580574.webp","isex":"2","isFz":"0","vipInfo":{},"mai":"2","meiNum":"0","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/14423_fd56a01b47f949f5bcb1690d62f4aa8e_ios_1698758120.gif?x-oss-process=image/format,png","isb":"1","id":"fd56a01b47f949f5bcb1690d62f4aa8e","maiNo":"2","nianl":30,"meiliNum":"0"},{"uname":"张七","caiLevel":1,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"0","vipInfo":{"isYcsl":"0","shenmiren_state":"0","nichengbianse":"0","isZcxh":"0","fangjianziliaoka":"0","wuhenliulan":"0","dingzhimingpai":"0","yincangsongli":"0","jinfanghuanyin":"0","yincangsongli_state":"0","zhuanshimingpai":"0","fangjinyanti":"0","zhucexiaohao":"0","wuhenliulan_state":"0","isFdrr":"0","fangdarao_type":"1","shenmiren":"0","isNcbs":"0","isSmi":"0","shengjipiaoping":"0","fangdarao":"0","zhuanshuliwu":"0"},"mai":"4","meiNum":"99","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1700894392197.webp","isb":"1","id":"a55c8bff42a34ff680e9238fe4b2fb79","maiNo":"4","nianl":22,"meiliNum":"99"},{"uname":"张二","caiLevel":70,"isJy":"0","isAdmin":"0","headKuang":"","isex":"2","isFz":"0","vipInfo":{},"mai":"5","meiNum":"297","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/head_img/20230929-031959.jpg","isb":"1","id":"1faf10205e754c7fa3cb5a3991175e2f","maiNo":"5","nianl":29,"meiliNum":"297"},{"uname":"张一","caiLevel":55,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"0","vipInfo":{},"mai":"6","meiNum":"297","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1700471609708.png","isb":"1","id":"c09bc0a54c494ae0bc7bb2dbfea43672","maiNo":"6","nianl":32,"meiliNum":"297"},{"uname":"张三","caiLevel":63,"isJy":"0","isAdmin":"0","headKuang":"","isex":"2","isFz":"0","vipInfo":{},"mai":"7","meiNum":"297","uimg":"https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1691403697988.jpg","isb":"1","id":"edff1ee31f3a4125b628c52958b06f25","maiNo":"7","nianl":33,"meiliNum":"297"},{"uname":"张五","caiLevel":1,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"0","vipInfo":{},"mai":"8","meiNum":"297","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/head_img/20230929-031959.jpg","isb":"1","id":"adee48d1a1c74d819da90cdeb6fc0fa2","maiNo":"8","nianl":22,"meiliNum":"297"}],"name":"哈欠不断扩大用户收入囊中","type":"200","shangxiatiao":"1"}
"""

        
        self.viewModel.receiveAllMaiListMessage(text: tempstring)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.viewModel.requestMainWeiList(houseId: "26663258") {
                
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.viewModel.modelArray_vm.value[4].isSpeaking = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            let str = """
        {"hotnum":"100","hotsum":"3073128","meiNum":"0","dataList":[{"mai":"5","meiNum":"80","id":"e4a7c97b69d946c4b93ce44034e93716"},{"mai":"0","meiNum":"30","id":"fd56a01b47f949f5bcb1690d62f4aa8e"}],"type":"201"}
"""
            self.viewModel.receiveCharmListMessage(text: str)
//            self.viewModel.modelArray_vm.value[3].isSpeaking = true
        }
        
        
        
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
    let allView = LQAllMailWeiView()
    allView.frame = CGRectMake(0, 0, ScreenConst.width, 220.fitScale())
    contentView.addSubview(allView)
    
    return contentView
    
//    LQMaiWeiViewController()
}

