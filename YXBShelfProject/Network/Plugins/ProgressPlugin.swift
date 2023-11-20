//
//  ProgressPlugin.swift
//  MyNetWork
//
//  Created by 杨晓斌 on 2023/7/20.
//

import Moya
//import MBProgressHUD

// MARK: 为了使用Moya自带的菊花插件，进行的调整
struct ProgressPlugin {
    func cteatProgressPlugin() -> NetworkActivityPlugin  {
        NetworkActivityPlugin { change, target in
            
            DispatchQueue.main.async {
                switch change {
                case .began:
//                    MBProgressHUD.showGif(to: UIApplication.shared.currentUIWindow())
                    debugPrint("菊花插件开始")
                case .ended:
//                    MBProgressHUD.hideGifHUD(for: UIApplication.shared.currentUIWindow())
                    debugPrint("菊花插件结束")
                }
            }
        }
    }
}
