//
//  GroupNoticeViewController.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/1/22.
//

import UIKit
import WebKit
import SnapKit
import Photos

/**
 * @brief  可编辑，可操作，可拍照，上传图片，上传文件的 富文本类。
 */
@objcMembers
class GroupNoticeViewController: GroupNoticeBaseViewController {
    
    let toolBarHeight: CGFloat = 44
    let menuViewHeight: CGFloat = 135
    let bottomSpace: CGFloat = 32
    
    var width: CGFloat {
        return self.view.frame.size.width
    }
    
    var height: CGFloat{
        return self.view.frame.size.height - 88 - 100
    }
    
    var colorHex: String = ""
    var backgroundColorHex: String = ""
    var isFontColor: Bool = false
        
    var moreBtnClick: Bool = false
    var keyboardWillShow: Bool = false
    
    var documentPickerPresenter: YXBDocumentPickerPresenter?
    
    lazy var editToolBar: GNEditToolBar = {
        let bar = GNEditToolBar(frame: CGRect(x: 0, y: self.view.frame.size.height, width: width, height: toolBarHeight))
        bar.backgroundColor = .backgroundColor_gray
        bar.delegate = self
        return bar;
    }()
    
    lazy var menuView: GNMenuView = {
        let view = GNMenuView(frame: .zero)
        view.backgroundColor = .backgroundColor_gray
        view.delegate = self
        return view;
    }()
    
//    lazy var cameraPresenter: CameraPresenter = {
//        let presenter = CameraPresenter()
//        presenter.delegate = self
//        return presenter
//    }()
    
    init(with room: YXBRoom) {
        super.init(with: room, canEdit: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor_gray
        self.title = "富文本"
        view.addSubview(webView)
        webView.frame = CGRectMake(0, 0, self.width, self.height)
        view.addSubview(editToolBar)
        view.addSubview(menuView)
        setNavigationBarItems()
        loadHTML();
        
        menuView.snp.makeConstraints { make in
            make.top.equalTo(editToolBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }
    
    override func loadHTML(){
        let bundlePath = Bundle.main.path(forResource: "QuillJs", ofType: "bundle")!
        let path = "file://\(bundlePath)/resource/index.html"
        guard let url = URL(string: path) else {
            return
        }
        let urlString = try? String(contentsOf: url, encoding: String.Encoding.utf8)
        webView.loadHTMLString(urlString!, baseURL: url)
    }
    
    private func setNavigationBarItems() {
        let item1 = UIBarButtonItem.init(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveAction))
        item1.tintColor = .tintColor
        self.navigationItem.rightBarButtonItem = item1
    }
    
   
    @objc func saveAction() {
        self.view.endEditing(true)
        
        webView.evaluateJavaScript("getHtml()") {[weak self] (val, err) in
            if let _val = val as? String {
                debugPrint(_val)
                
                let fileList: [[String: Any]] = self?.fileList.map{ fileModel in
                    return [
                        "type": fileModel.type ?? "",
                        "file_name": fileModel.file_name ?? "",
                        "file_size": fileModel.file_size ?? 0,
                        "file_url": fileModel.file_url ??  "",
                        "id": fileModel.id ?? ""
                    ]
                } ?? []
                var parmas: [String: Any] = ["announcement": ["content": _val,
                                                              "sourceRoomId": self?.myRoom.roomId,
                                                              "file_list": fileList]]
                
                self?.myRoom.setGroupAnnouncementWithContent(parmas) { str in
                    
//                    if let targetViewController = self?.navigationController?.viewControllers.first(where: { $0.isKind(of: RoomViewController.self) }) {
//                        self?.navigationController?.popToViewController(targetViewController, animated: true)
//                    } else {
                        self?.navigationController?.popViewController(animated: true)
//                    }
                    
                } failure: { error in
                    self?.view.makeToast(error?.localizedDescription ?? "", duration: 2)
                }
            }
        }
    }
    
    // WKScriptMessageHandler
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let methodName = message.name
        let methodMessage = message.body
        debugPrint("receive js message ", methodMessage)
        if methodName == "logger" {
            
        } else if methodName == "actions" {
            if let actions = methodMessage as? Dictionary<String, Any> {
                editToolBar.updateButtonItemStatus(actions)
            }
        } else if methodName == "getAppThemeBeforeLoaded" {
            // 切换主题
            /*
            if !ThemeService.shared().isCurrentThemeDark() {
                self.changeQuillThemeColor(theme: .light)
            }
            */
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.fileList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupNoticeFileCell", for: indexPath) as! GroupNoticeFileCell
        cell.selectionStyle = .none
        cell.setup(model: model)
        cell.deleteClosure = {[weak self] selectModel in
            guard let selectModel = selectModel else { return }
            guard let self = self else { return }
            guard let index = self.fileList.firstIndex(of: selectModel) else { return }
            self.fileList.remove(at: index)
            self.tableView.reloadData()
        }
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: KeyBoard
private extension GroupNoticeViewController {
    func addObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardFrameChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyBoardFrameChange(_ notifocation: Notification){
        // 1.Obtain the animation execution time
        let duration = notifocation.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 2.Get the final Y value of the keyboard
        let endFrame = (notifocation.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y

//        self.webView.setNeedsLayout()
        
        var toolBarY: CGFloat = self.view.frame.size.height
        if keyboardWillShow {
            toolBarY = y - self.toolBarHeight - 88
        }
        
        if keyboardWillShow == false && moreBtnClick {
            toolBarY = self.view.frame.size.height - self.toolBarHeight - bottomSpace - menuViewHeight
        }
        
        if keyboardWillShow == false && moreBtnClick == false {
            toolBarY = (y >= self.view.frame.size.height ? y : self.view.frame.size.height)
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.editToolBar.frame = CGRect(x: 0, y: toolBarY, width: self.width, height: self.toolBarHeight)
            // fix menuView animate
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }) { (complete) in
        }
    }
    
    @objc func keyBoardWillShow(_ notifocation: Notification){
        keyboardWillShow = true
        self.keyBoardFrameChange(notifocation)
        self.moreBtnClick = false
    }
    
    @objc func keyBoardWillHide(_ notifocation: Notification){
        keyboardWillShow = false
        self.keyBoardFrameChange(notifocation)
    }
}
