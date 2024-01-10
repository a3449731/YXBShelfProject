//
//  ChartsViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/26.
//

import UIKit

class ChartsViewController: UIViewController {
    
    let chartView: BillBarChartView = BillBarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        
        
        chartView.configChartData(data: ["1", "2", "3"])
    }
}
