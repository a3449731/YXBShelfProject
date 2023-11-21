//
//  MSDressSegmentVC.swift
//  YXBSwiftProject
//
//  Created by 蓝鳍互娱 on 2023/10/20.
//  Copyright © 2023 ShengChang. All rights reserved.
//

import UIKit
import JXSegmentedView
import RxSwift
import RxCocoa

class MSDressSegmentVC: UIViewController {
    // 外界传入
    // 是否是我的背包,
    @objc var isMyBeiBao: Bool = false
    
    let disposed = DisposeBag()
    var currentChooseModel: MSDressModel? {
        didSet {
            self.adjustUseButton()
        }
    }
        
    // 标题模型
    private var titleModelArray: [MSDressType] = MSDressType.allCases
    private var titleArray: [String] = []
    
    let previewContentView = UIView()
    // 预览
    lazy var previewView: MSDressPreviewView = {
        let view = MSDressPreviewView()
        return view
    }()
    
    let segmentedView = JXSegmentedView()
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    lazy var buyButton: UIButton = {
        let button = MyUIFactory.commonGradientButton(title: "立即购买", titleColor: .titleColor_white, titleFont: .titleFont_14, image: nil)
        button.isHidden = self.isMyBeiBao
        button.layerCornerRadius = 18.fitScale()
        button.makeGradient([.gradientColor_redStart, .gradientColor_redEnd])
        return button
    }()
    
    // 佩戴和取消佩戴的button
    lazy var useButton: UIButton = {
        let button = MyUIFactory.commonGradientButton(title: "立即佩戴", titleColor: .titleColor_white, titleFont: .titleFont_14, image: nil)
        button.isHidden = true
        button.layerCornerRadius = 18.fitScale()
        button.makeGradient([.gradientColor_redStart, .gradientColor_redEnd])
        button.addTarget(self, action: #selector(useButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isMyBeiBao {
            self.title = "我的背包"
        } else {
            self.title = "装扮中心"
        }
//        self.naviImageView?.backgroundColor = .clear;
//        self.rightButton?.isHidden = false
//        self.rightButton?.setTitle( self.isMyBeiBao ? "装扮中心" : "我的背包", for: .normal)
//        self.rightButton?.frame = CGRect(x: ScreenConst.width - 10.0 - 100.0, y: ScreenConst.statusBarHeight , width: 100, height: 40)
//        self.rightButton?.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)

        self.view.backgroundColor = .backgroundColor_white
        self.setupUI()
        self.setupTools()
        self.setupData()
    }
    
    private func setupUI() {
        
        let backgroundIamgeView = UIImageView()
        backgroundIamgeView.image = UIImage(named: "wode_dress_background")
        backgroundIamgeView.contentMode = .scaleToFill
        self.view.insertSubview(backgroundIamgeView, at: 0)
        backgroundIamgeView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let backgroundTopIamgeView = UIImageView()
        backgroundTopIamgeView.image = UIImage(named: "wode_dress_background_top")
        backgroundTopIamgeView.contentMode = .scaleToFill
//        self.view.addSubview(backgroundTopIamgeView)
        self.view.insertSubview(backgroundTopIamgeView, at: 1)
        backgroundTopIamgeView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(146.fitScale())
        }
        
        // - 标题
        segmentedView.delegate = self
        self.view.addSubview(self.segmentedView)
        self.segmentedView.snp.makeConstraints { make in
            make.top.equalTo(ScreenConst.navStatusBarHeight + 170.fitScale() + 15.fitScale())
            make.left.equalTo(0)
            make.right.equalTo(-0)
            make.height.equalTo(35)
        }
        
        //      - 初始化指示器indicator
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 10
        indicator.indicatorHeight = 3
        indicator.indicatorColor = .indicatorColor_black
        indicator.indicatorPosition = .bottom
        segmentedView.indicators = [indicator]
        
        //  - 内容
        let listContainerView = JXSegmentedListContainerView(dataSource: self)
        // 禁止滑动，只能点击
        listContainerView.scrollView.isScrollEnabled = false
        self.view.addSubview(listContainerView)
        //关联listContainer
        segmentedView.listContainer = listContainerView
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ScreenConst.bottomSpaceHeight - 50.fitScale())
        }
        
        self.view.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.width.equalTo(122.fitScale())
            make.right.equalTo(-15.fitScale())
            make.height.equalTo(36.fitScale())
            make.bottom.equalToSuperview().offset(-ScreenConst.bottomSpaceHeight)
        }
        
        self.view.addSubview(useButton)
        useButton.snp.makeConstraints { make in
            make.width.equalTo(122.fitScale())
            make.right.equalTo(-15.fitScale())
            make.height.equalTo(36.fitScale())
            make.bottom.equalToSuperview().offset(-ScreenConst.bottomSpaceHeight)
        }
        
        // 这个放到下面是为了省去播放特效的时候，特效可以展示在上层。
        self.view.addSubview(previewContentView)
        previewContentView.snp.makeConstraints { make in
            make.top.equalTo(ScreenConst.navStatusBarHeight + 10.fitScale())
            make.left.equalTo(15.fitScale())
            make.right.equalTo(-15.fitScale())
            make.height.equalTo(160.fitScale())
        }
                        
        let preViewImageView = UIImageView()
        preViewImageView.image = UIImage(named: "wode_dress_preview")
        previewContentView.addSubview(preViewImageView)
        preViewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addPreView()
    }
    
    private func setupTools() {
        buyButton.rx.tap
            .subscribe(onNext: { [weak self] event in
                debugPrint("点击了购买")
                guard let self = self else { return }
                self.configBuyAction()
            })
            .disposed(by: disposed)
        
        self.creatNotification()
    }
    
    private func setupData() {
        // 配置数据源相关配置属性
        segmentedDataSource.titles = []
        segmentedDataSource.titleSelectedFont = .titleFont_14
        segmentedDataSource.titleSelectedColor = .titleColor
        segmentedDataSource.titleNormalFont = .titleFont_14
        segmentedDataSource.titleNormalColor = .subTitleColor
        segmentedDataSource.isItemSpacingAverageEnabled = true
//        segmentedDataSource.itemSpacing = 24
        
        segmentedDataSource.isTitleColorGradientEnabled = true
        // 关联dataSource
        segmentedView.dataSource = self.segmentedDataSource
        segmentedView.defaultSelectedIndex = 0
        
        
        // 请求标题数据,刷新数据
        self.requestDressCategories()
    }
    
    // 请求标题数据
    private func requestDressCategories() {
        // 这个标题是本地写的，没有接口。
        self.titleArray = self.titleModelArray.map { type in
            type.title
        }
        self.segmentedDataSource.titles = self.titleArray
        self.segmentedView.reloadData()
    }
    
    
    // MARK: 点击购买按钮
    private func configBuyAction() {
        if self.currentChooseModel == nil {
            self.view.makeToast("请先选择装扮")
            return
        }
        
        if let model = self.currentChooseModel,
           model.isZs == "1",
           isMyBeiBao == false {
            self.view.makeToast("此装扮为\(model.vipLevel ?? "")贵族专属，暂不能购买")
            return
        }
        
        let vc = MSDressBuyVC()
        vc.model = self.currentChooseModel ?? MSDressModel()
        vc.delegate = self 
        vc.modalPresentationStyle = .overFullScreen;
        self.navigationController?.present(vc, animated: false, completion: {
//            vc.view.superview?.backgroundColor = .clear
        })
    }
    
    // MARK: 点击佩戴 和 取消 佩戴
    @objc func useButtonAction() {
        let str = self.useButton.titleForNormal
        if str == "取消佩戴" {
            if let zbid = self.currentChooseModel?.id {
                let index = self.segmentedView.selectedIndex
                let type = self.titleModelArray[index]
                let network = NetworkManager<MyAPI>()
                network.sendRequest(.cancelUserUsedZb(zbId: zbid, type: type.rawValue)) { [weak self] obj in
                    guard let self = self else { return }
                    self.view.makeToast("操作成功", position: .center)
                    self.currentChooseModel = nil
                    // 佩戴成功让其刷新里面的列表数据
                    if let content = self.segmentedView.listContainer as? JXSegmentedListContainerView,
                       let vc = content.validListDict[index] as? MSDressCenterVC {
                        vc.setupData()
                    }
                }
            }
        }
        if str == "立即佩戴" {
            if let zbid = self.currentChooseModel?.id {
                let index = self.segmentedView.selectedIndex
                let type = self.titleModelArray[index]
                let network = NetworkManager<MyAPI>()
                network.sendRequest(.userUsedZb(zbId: zbid, type: type.rawValue)) { [weak self] obj in
                    guard let self = self else { return }
                    self.view.makeToast("操作成功", position: .center)
                    self.currentChooseModel = nil
                    // 佩戴成功让其刷新里面的列表数据
                    if let content = self.segmentedView.listContainer as? JXSegmentedListContainerView,
                       let vc = content.validListDict[index] as? MSDressCenterVC {
                        vc.setupData()
                    }
                }
            }
        }
    }
    
    private func adjustUseButton() {
        if self.isMyBeiBao {
            if let model = self.currentChooseModel {
                self.useButton.isHidden = false
                if model.isUsed {
                    self.useButton.setTitle("取消佩戴", for: .normal)
                } else {
                    self.useButton.setTitle("立即佩戴", for: .normal)
                }
            } else {
//                self.useButton.setTitle("", for: .normal)
                self.useButton.isHidden = true
            }
        }
    }
    
    // MARK: 点击我的背包
    @objc func rightButtonAction() {
        if self.isMyBeiBao {
            let vc = MSDressSegmentVC()
            vc.isMyBeiBao = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = MSDressSegmentVC()
            vc.isMyBeiBao = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    deinit {
        self.removeNotication()
        debugPrint(self.className + " deinit 🍺")
    }

}

// MARK: -JXSegmentedViewDelegate 标签
extension MSDressSegmentVC: JXSegmentedViewDelegate {
    // 在滚动和选中到下一页时要清空选中
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let content = self.segmentedView.listContainer as? JXSegmentedListContainerView {
            content.validListDict.forEach { i, _ in
                if let vc = content.validListDict[i] as? MSDressCenterVC {
                    let array = Array(repeating: false, count: vc.viewModel.seletArray.value.count)
                    vc.viewModel.seletArray.accept(array)
                    vc.collectionView.reloadData()
                    self.currentChooseModel = nil
                }
            }
        }
        
        // 对预览进行重建,先删除再添加。 懒得改以前的逻辑了。
        self.stopAnimation()
        self.removePreView()
        self.addPreView()
        self.showHeader()
        
    }
}

// MARK: -JXSegmentedListContainerViewDataSource 分页的控制器
extension MSDressSegmentVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let titleModel = self.titleModelArray[index]
        let vc = MSDressCenterVC()
        vc.currentType = titleModel
        vc.isMyBeiBao = self.isMyBeiBao
        // 添加监听
        self.receiveTap(vc: vc)
        
        return vc
    }
    
    // MARK: 收到了点击了里面cell的回调
    private func receiveTap(vc: MSDressCenterVC) {
        vc.collectionView.rx.modelSelected(MSDressModel.self)
            .debug("12323112")
            .subscribe(onNext: { [weak self] model in
                debugPrint("首页收到的点击事件 ......")
                guard let self = self else { return }
                self.currentChooseModel = model
//                self.showAnimation()
                self.showStaticImage()
//                self.adjustUseButton()
            })
            .disposed(by: disposed)
    }
    
    // MARK: 点击了播放按钮
    @objc private func clickPlayButtonAction() {
        self.showAnimation()
    }
}

// MARK: 对预览的操作
extension MSDressSegmentVC {
    private func addPreView() {
        let index = self.segmentedView.selectedIndex
        self.previewView.addTo(superView: previewContentView, type: self.titleModelArray[index])
    }
    
    private func removePreView() {
        self.previewView.removeForm(superView: previewContentView)
    }
    
    private func showHeader() {
        let index = self.segmentedView.selectedIndex
        let type = self.titleModelArray[index]
        if type == .header {
            self.previewView.showHeader(type: self.titleModelArray[index])
        }
    }
    
    private func showStaticImage() {
        let index = self.segmentedView.selectedIndex
        let type = self.titleModelArray[index]
        if type == .header {
            self.previewView.showStaticImage(urlString: (self.currentChooseModel?.texiao) ?? "", type: self.titleModelArray[index])
        } else {
            self.previewView.showStaticImage(urlString: (self.currentChooseModel?.img) ?? "", type: self.titleModelArray[index])
        }
    }
    
    private func showAnimation() {
        let index = self.segmentedView.selectedIndex
        self.previewView.showAnimation(selectModel: self.currentChooseModel, type: self.titleModelArray[index])
    }
    
    private func stopAnimation() {
        self.previewView.stopAnimation()
    }
}

// MARK: 购买成功的回调
extension MSDressSegmentVC: MSDressBuyDeleagte {
    func didBuySuccess() {
        if let content = self.segmentedView.listContainer as? JXSegmentedListContainerView,
            let vc = content.validListDict[self.segmentedView.selectedIndex] as? MSDressCenterVC {
            vc.setupData()
        }
    }
}

// 通知,这个通知主在修复bug而偷懒的。
private extension MSDressSegmentVC {
    private func creatNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(mp4DidStartNotification), name: Notification.Name("MP4DidStart_Notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mp4DidStopNotification), name: Notification.Name("MP4DidStop_Notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickPlayButtonAction), name: NSNotification.Name("clickPlayButton"), object: nil)
        
    }
    
    @objc private func mp4DidStartNotification() {
        self.previewContentView.snp.remakeConstraints { make in
            make.top.equalTo(ScreenConst.navStatusBarHeight + 10.fitScale())
            make.left.equalTo(15.fitScale())
            make.right.equalTo(-15.fitScale())
            make.height.equalTo(ScreenConst.height)
        }
    }
    
    @objc private func mp4DidStopNotification() {
        self.previewContentView.snp.remakeConstraints { make in
            make.top.equalTo(ScreenConst.navStatusBarHeight + 10.fitScale())
            make.left.equalTo(15.fitScale())
            make.right.equalTo(-15.fitScale())
            make.height.equalTo(160.fitScale())
        }
    }
    
    private func removeNotication() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MP4DidStart_Notification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MP4DidStop_Notification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("clickPlayButton"), object: nil)
    }
}
