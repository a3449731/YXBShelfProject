//
//  ExampleViewController.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/11/20.
//

import UIKit

enum ExampleType: String, CaseIterable {
    case vap = "vap特效播放，队列播放"
    case message = "消息列表"
    case dress = "装扮中心+MVVM+Rx"
    case mvvm = "MVVM+Rx+MJ加载gif图"
    case banner = "轮播图"
    case browser = "预览图片"
    case download = "资源文件下载库"
    case loading = "加载, MBProgress+Gif"
    case mask = "Mask的转场动画"
    case floatScreen = "飘屏，队列与动画解耦"
    case micropphone = "麦位, Rx双向绑定"
    case pk = "房内pk"
    case dragTableView = "可拖动Cell的TableView"
    case dialog = "消息弹窗SwiftMessage"
    case db = "realm 数据库"
}

class ExampleViewController: UIViewController {
    
    @objc lazy var tableview: UITableView = {
        let table = UITableView(frame: self.view.bounds)
        table.backgroundColor = .gray
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(cellWithClass: UITableViewCell.self)
        table.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0;
        }
//        table.applyGradientMask(forFadeLength: 15)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ScreenConst.navStatusBarHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ExampleType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = ExampleType.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = ExampleType.allCases[indexPath.row]
        switch type {
            
        case .vap:
            let vc = RoomPlayViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .message:
            let vc = MessageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .dress:
            let vc = MSDressSegmentVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .mvvm:
            let vc = MSSystemNoticeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .banner:
            let vc = BannerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .browser:
            let vc = BrowswerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .download:
            let vc = DownloadViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .loading:
            let vc = LoadingGiftViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .mask:
            let vc = MaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .floatScreen:
            let vc = PiaoPingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .micropphone:
            let vc = LQMaiWeiViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .pk:            
            let vc = LQPKMaiWeiViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .dragTableView:
            let vc = DragTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .dialog:
            let vc = DialogViewController()
            self.navigationController?.pushViewController(vc, animated: true) 
        case .db:
            let vc = RealmViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
