//
//  GroupNoticeBaseViewController.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/2/7.
//

import UIKit
import WebKit

@objcMembers
class GroupNoticeBaseViewController: UIViewController {

    // 切换富文本编辑器的主题色，支持黑白两种
    enum QuillThemeColor: String {
        case light = "light"
        case dark = "dark"
    }
    
    // 并没有什么鸟用，时间问题，没完全摘除干净
    let myRoom: YXBRoom
    let canEdit: Bool
    
    // data
    var announcementDic: [String: Any]? {
        didSet {
            self.htmlContent = announcementDic?["content"] as? String
            self.fileList = GroupNoticeFileModel.models(fromJSON: announcementDic?["file_list"] as? [Any] ?? [])
        }
    }
    var htmlContent: String?
    var lastedHtmlContent: String?
    var fileList: [GroupNoticeFileModel] = []
    
    @objc init(with room: YXBRoom, canEdit: Bool) {
        self.myRoom = room
        self.canEdit = canEdit
        super.init(nibName:nil,bundle: nil)
    }
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration.init()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        // fix down postion
        preferences.minimumFontSize = 0.0
        let userContentController = WKUserContentController.init();
        let weakScriptMessageHandle = GNWeakScriptMessageDelegate.init(self)
        userContentController.add(weakScriptMessageHandle, name: "logger")
        userContentController.add(weakScriptMessageHandle, name: "actions")
        userContentController.add(weakScriptMessageHandle, name: "getAppThemeBeforeLoaded")
        
        config.userContentController = userContentController
        config.preferences = preferences
        
        let webView = GNRichEditorWebView.init(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        // fix ios14 crash
        //        FauxBarHelper().removeInputAccessoryView(webView: webView)        
        // fix white flicker
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView;
    }()
    
    @objc lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = .backgroundColor_gray
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(GroupNoticeFileCell.self, forCellReuseIdentifier: "GroupNoticeFileCell")
        table.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0;
        }
        table.estimatedRowHeight = 62
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor_gray
        self.title = "富文本"
        self.setNavigationBarItems()
        view.addSubview(webView)
        loadHTML()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(240)
        }
    }
        
    private func setNavigationBarItems() {
        if (self.canEdit) {
            let item1 = UIBarButtonItem.init(title: "编辑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(eiditAction))
            item1.tintColor = .tintColor
            self.navigationItem.rightBarButtonItem = item1
        }
        
        let backItem = UIBarButtonItem(image: UIImage(named: "wode_dress_accrow"), style: .plain, target: self, action: #selector(onCancel))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc private func onCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func eiditAction() {

    }
    
    func loadHTML() {
//        let bundlePath = Bundle.main.bundlePath
        let bundlePath = Bundle.main.path(forResource: "QuillJs", ofType: "bundle")!
        let path = "file://\(bundlePath)/resource/preview.html"
        guard let url = URL(string: path) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request);
    }
    
    func setContent() {
        guard htmlContent != nil else {
            return
        }
        
        webView.evaluateJavaScript("insertContent('\(htmlContent!)')") { (val, err) in
            debugPrint("val: \(val ?? ""), err: \(String(describing: err))")
        }
    }
    
    func changeQuillThemeColor(theme: GroupNoticeViewController.QuillThemeColor) {
        webView.evaluateJavaScript("changeTheme('\(theme.rawValue)')") { val, err in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height - 300)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupNoticeBaseViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let methodName = message.name
        let methodMessage = message.body
        debugPrint("receive js message ", methodMessage)
        if methodName == "getAppThemeBeforeLoaded" {
            // 切换主题
            /*
            if !ThemeService.shared().isCurrentThemeDark() {
                self.changeQuillThemeColor(theme: GroupNoticeViewController.QuillThemeColor.light)
            }
            */
        }
    }
}

extension GroupNoticeBaseViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 切换主题
        /*
        if !ThemeService.shared().isCurrentThemeDark() {
            self.changeQuillThemeColor(theme: GroupNoticeViewController.QuillThemeColor.light)
        }
        */
        
        self.setContent()
    }
}

extension GroupNoticeBaseViewController: UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.fileList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupNoticeFileCell", for: indexPath) as! GroupNoticeFileCell
        cell.selectionStyle = .none
        cell.setup(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.fileList[indexPath.row]
        guard let file_url = model.file_url else { return }
        guard let url = URL(string: file_url) else { return }
        // 然后需要下载到本地，给本地路径才能预览
        
        // 这里直接找个本地文件替代试试效果
        let bundlePath = Bundle.main.path(forResource: "QuillJs", ofType: "bundle")!
        let path = "file://\(bundlePath)/resource/main.js"
        guard let localUrl = URL(string: path) else { return }
        let documentInteractionController = UIDocumentInteractionController(url: localUrl)
        documentInteractionController.delegate = self
        documentInteractionController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
        
}
