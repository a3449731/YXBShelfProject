//
//  AppDelegate+SwiftyBeaver.swift
//  YXBShelfProject
//
//  Created by yangxiaobin on 2023/12/24.
//

import SwiftyBeaver

let log = SwiftyBeaver.self


extension AppDelegate {
    func setupLogConfig() {        
        
        // add log destinations. at least one is needed!
        // Xcode控制台日志
        let console = ConsoleDestination()  // log to Xcode Console
        // 默认swiftybeaver.log文件日志
        let file = FileDestination()  // log to default swiftybeaver.log file
        // cloud平台配置
//        let cloud = GoogleCloudDestination(serviceName: "")
        
//        // use custom format and set console output to short time, log level & message
//        console.format = "$DHH:mm:ss$d $L $M"
//         or use this for JSON output: console.format = "$J"
//        console.format = "$J"
        
        // 可以改变默认的颜色，自定义颜色
//        console.levelColor.verbose = "fg255,0,255;"
//        console.levelColor.debug = "fg255,100,0;"
//        console.levelColor.info = ""
//        console.levelColor.warning = "fg255,255,255;"
//        console.levelColor.error = "fg100,0,200;"
        
        // 添加配置到SwiftyBeaver
        log.addDestination(console)
        log.addDestination(file)
        
        
        log.verbose("not so important")                 // 优先级 1, VERBOSE   紫色
        log.debug("something to debug")                 // 优先级 2, DEBUG     绿色
        log.info("a nice information")                  // 优先级 3, INFO      蓝色
        log.warning("oh no, that won’t be good")        // 优先级 4, WARNING   黄色
        log.error("ouch, an error did occur!")          // 优先级 5, ERROR     红色
                
        //支持类型: 字符串,数字,日期,等等
        log.verbose(123)
        log.info(-123.45678)
        log.warning(Date())
        log.error(["I", "like", "logs!"])
        log.error(["name": "Mr Beaver", "address": "7 Beaver Lodge"])
        
    }
}
