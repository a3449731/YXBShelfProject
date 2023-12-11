//
//  LQPKMaiWeiViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/7.
//

import UIKit

class LQPKMaiWeiViewController: UIViewController {
    
    lazy var nineView: LQPKMaiWeiView = {
        let view = LQPKMaiWeiView(roomType: "2")
        view.delegate = self
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(nineView)
        nineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ScreenConst.navStatusBarHeight + 10)
            make.left.right.equalToSuperview()
            make.height.equalTo(300.fitScale())
        }
        
        self.setupData()
    }
    
    private func setupData() {

        let tempstring = """
        {"biList":["1"],"suoList":["3"],"maiweiNameList":[{"name":"不是说我","id":"a7e79ab70e914d8c820df6fa669ff172","maino":"4"}],"dataList":[{"uname":"张四","caiLevel":29,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"1","vipInfo":{},"mai":"0","meiNum":"4752","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/head_img/20230929-031959.jpg","isb":"1","id":"e8394b2c4c2d489fa41b62922546077d","maiNo":"0","nianl":28,"meiliNum":"4752"},{"uname":"哈欠不断扩大用户收入囊中","caiLevel":101,"isJy":"0","jueName":"","isAdmin":"0","headKuang":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241580574.webp","isex":"2","isFz":"0","vipInfo":{},"mai":"2","meiNum":"0","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/14423_fd56a01b47f949f5bcb1690d62f4aa8e_ios_1698758120.gif?x-oss-process=image/format,png","isb":"1","id":"fd56a01b47f949f5bcb1690d62f4aa8e","maiNo":"2","nianl":30,"meiliNum":"0"},{"uname":"张七","caiLevel":1,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"0","vipInfo":{"isYcsl":"0","shenmiren_state":"0","nichengbianse":"0","isZcxh":"0","fangjianziliaoka":"0","wuhenliulan":"0","dingzhimingpai":"0","yincangsongli":"0","jinfanghuanyin":"0","yincangsongli_state":"0","zhuanshimingpai":"0","fangjinyanti":"0","zhucexiaohao":"0","wuhenliulan_state":"0","isFdrr":"0","fangdarao_type":"1","shenmiren":"0","isNcbs":"0","isSmi":"0","shengjipiaoping":"0","fangdarao":"0","zhuanshuliwu":"0"},"mai":"4","meiNum":"99","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1700894392197.webp","isb":"1","id":"a55c8bff42a34ff680e9238fe4b2fb79","maiNo":"4","nianl":22,"meiliNum":"99"},{"uname":"张二","caiLevel":70,"isJy":"0","isAdmin":"0","headKuang":"","isex":"2","isFz":"0","vipInfo":{},"mai":"5","meiNum":"297","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/head_img/20230929-031959.jpg","isb":"1","id":"1faf10205e754c7fa3cb5a3991175e2f","maiNo":"5","nianl":29,"meiliNum":"297"},{"uname":"张一","caiLevel":55,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"0","vipInfo":{},"mai":"6","meiNum":"297","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1700471609708.png","isb":"1","id":"c09bc0a54c494ae0bc7bb2dbfea43672","maiNo":"6","nianl":32,"meiliNum":"297"},{"uname":"张三","caiLevel":63,"isJy":"0","isAdmin":"0","headKuang":"","isex":"2","isFz":"0","vipInfo":{},"mai":"7","meiNum":"297","uimg":"https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1691403697988.jpg","isb":"1","id":"edff1ee31f3a4125b628c52958b06f25","maiNo":"7","nianl":33,"meiliNum":"297"},{"uname":"张五","caiLevel":1,"isJy":"0","isAdmin":"0","headKuang":"","isex":"1","isFz":"0","vipInfo":{},"mai":"8","meiNum":"297","uimg":"https://lanqi123.oss-cn-beijing.aliyuncs.com/head_img/20230929-031959.jpg","isb":"1","id":"adee48d1a1c74d819da90cdeb6fc0fa2","maiNo":"8","nianl":22,"meiliNum":"297"}],"name":"哈欠不断扩大用户收入囊中","type":"200","shangxiatiao":"1"}
"""
        
        if let dic = try? tempstring.data(using: .utf8)?.jsonObject() as? [String: Any] {
            self.nineView.viewModel.receiveAllMaiListMessage(dic:dic , roomType: .merchant_9)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.nineView.viewModel.requestMainWeiList(houseId: "26663258", roomType: .merchant_9) {
//
//            }
//        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.nineView.viewModel.modelArray_vm.value[2].isSpeaking = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            let str = """
        {"hotnum":"100","hotsum":"3073128","meiNum":"0","dataList":[{"mai":"5","meiNum":"80","id":"e4a7c97b69d946c4b93ce44034e93716"},{"mai":"0","meiNum":"30","id":"fd56a01b47f949f5bcb1690d62f4aa8e"}],"type":"201"}
"""
            
            if let dic = try? str.data(using: .utf8)?.jsonObject() as? [String: Any] {
                self.nineView.viewModel.receiveCharmListMessage(dic: dic, roomType: .merchant_9)
            }
//            self.viewModel.modelArray_vm.value[3].isSpeaking = true
        }
    }
    
    //        contentView.backgroundColor = .cyan
    //        contentView.userView.headerView.setImage(url: "https://misheng001-1318856868.cos.ap-nanjing.myqcloud.com/1690792476235.jpg", headerFrameUrl: "https://lanqi123.oss-cn-beijing.aliyuncs.com/file/1699241627225.webp", placeholderImage: UIImage(named: "CUYuYinFang_login_logo"))
    //        contentView.hStack.backgroundColor = .black
    //        contentView.titleLabel.text = "Ss.草电风扇申达股份."
    //        contentView.sortLabel.text = "4"
    //        contentView.identityImageView.image = UIImage(named: "CUYuYinFang_fanzhuHead")
    //        contentView.charmButton.setTitle("1000w", for: .normal)
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
}

// MARK: - LQAllMailWeiViewDelegate点击事件的回调
extension LQPKMaiWeiViewController: LQPKMailWeiViewDelegate {
    // 点击了麦位的icon。 isHostMai:表示是否是主持麦。 roomType:房间类型，因为是给OC用就不能用枚举传递了
    func mailWeiListDidTapMaiWeiIcon(view: LQPKMaiWeiView, model: LQMaiWeiModel, isHostMai: Bool, roomType: String) {
        debugPrint("点击了icon，是房主吗", isHostMai)
        debugPrint("点击了icon，房间类型", roomType)
        debugPrint("点击了icon，模型数据", model.toJSON())
    }
    
    func mailWeiListDidTapUserHeader(view: LQPKMaiWeiView, model: LQMaiWeiModel, isHostMai: Bool, roomType: String) {
        debugPrint("点击了用户头像，是房主吗", isHostMai)
        debugPrint("点击了用户头像，房间类型", roomType)
        debugPrint("点击了用户头像，模型数据", model.toJSON())
    }
    
    func mailWeiListDidTapCharmView(view: LQPKMaiWeiView, model: LQMaiWeiModel, isHostMai: Bool, roomType: String) {
        debugPrint("点击了魅力值，是房主吗", isHostMai)
        debugPrint("点击了魅力值，房间类型", roomType)
        debugPrint("点击了魅力值，模型数据", model.toJSON())
    }    
}

#Preview {
    LQPKMaiWeiViewController()
}
