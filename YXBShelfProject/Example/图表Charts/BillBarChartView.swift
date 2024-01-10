//
//  BillBarChartView.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/26.
//

import UIKit
import DGCharts

/// DGCharts既为Swift著名三方Charts，因与SwiftUI内置库重名，遂改名了。

// 账单的柱状图
class BillBarChartView: UIView {
    
    // 扇形图
    lazy var chartView: BarChartView = {
        let chartView = BarChartView()
        chartView.delegate = self
        
        // 禁止拖动
        chartView.dragEnabled = false
        // 禁止双击缩放
        chartView.doubleTapToZoomEnabled = false
        // 禁止缩放
        chartView.setScaleEnabled(false)
                
        // 右侧y轴，隐藏。不需要
        chartView.rightAxis.enabled = false
        // 是否在柱状上面显示y值。
        chartView.drawValueAboveBarEnabled = true
                
        // 立柱阴影. 开启立柱背景阴影绘制后，立柱未占用的部分会有深灰色背景。
        chartView.drawBarShadowEnabled = true
                
        
        // x轴
        let xAxis = chartView.xAxis
        // 让x轴在底下
        xAxis.labelPosition = .bottom
        // 控制轴线上label显示的步长。 这里表示隔5个一显示
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        
        // 左边的y轴
        let leftAxis = chartView.leftAxis
        // 没试出来这是干嘛的
//        leftAxis.drawBottomYLabelEntryEnabled = false
//        leftAxis.drawTopYLabelEntryEnabled = false
        
        // 是否翻转绘制
//        leftAxis.inverted = true
        
        // 这三行是控制起始线的。
        leftAxis.drawZeroLineEnabled = true
        leftAxis.zeroLineWidth = 10
        leftAxis.zeroLineColor = .red
        
        // y轴数据里的最大值，距离y轴顶部的差距,以总轴范围的百分比表示
//        leftAxis.spaceTop = 5
        // y轴数据里的最小值，距离y轴底部的差距,以总轴范围的百分比表示
//        leftAxis.spaceBottom = 2
        
        // y轴线上label，是在表内还是表外
//        leftAxis.labelPosition = .insideChart
        // y轴线上label，的对齐方式
//        leftAxis.labelAlignment = .left
        // y轴线上label, 水平轴方向上的偏移
//        leftAxis.labelXOffset = 10
        
        // 轴的最小宽度，说的好像是预留左边
//        leftAxis.minWidth = 100
                
        // y轴线的相关设置
//        leftAxis.axisLineColor = .yellow
//        leftAxis.axisLineWidth = 5
        
        // 网络线
//        leftAxis.gridColor = .systemPink
//        leftAxis.gridLineWidth = 5
        // 虚线的 长度 和 间隔
//        leftAxis.gridLineDashLengths = [10, 5]
        // 应该是虚线的起始位置，但没试验出是什么效果
//        leftAxis.gridLineDashPhase = 100
                
        // 是否画y轴的 网格线
        leftAxis.drawGridLinesEnabled = false
        // 是否画y轴的 轴线
//        leftAxis.drawAxisLineEnabled = false
        // 是否画y轴的 轴线的数值
//        leftAxis.drawLabelsEnabled = false
                
        // 对图例legend的相关设置
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 30)!
        l.xEntrySpace = 4
        
        return chartView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
        
        
        //生成10条随机数据
        var dataEntries = [BarChartDataEntry]()
        for i in 1..<12 {
            let y = arc4random()%100
            let entry = BarChartDataEntry(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        //这20条数据作为柱状图的所有数据
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "图例1")
        
        // 设置柱子的颜色
        chartDataSet.colors = [.blue, .cyan]
        
        // 柱状图的边框
        chartDataSet.barBorderColor = .yellow
        chartDataSet.barBorderWidth = 2
        
        // 是否显示具体数值
//        chartDataSet.drawValuesEnabled = false
        // 具体数值的颜色
        chartDataSet.valueTextColor = .red
        
        //目前柱状图只包括1组立柱
        let chartData = BarChartData(dataSets: [chartDataSet])
        //设置柱子宽度为刻度区域的一半
        chartData.barWidth = 0.5
        
        
        //设置柱状图数据
        chartView.data = chartData
    }
    
    private func creatUI() {
        addSubview(chartView)
        
        chartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 设置图表数据
    func configChartData(data: [String]) {
        
//        let xyValues = data.enumerated().map { (index, str) in
//            BarChartDataEntry(x: Double(index + 1), y: Double(str) ?? 0)
//        }
//        
//        // 一个集合表示一个图形的数据
//        let dataSet = BarChartDataSet(entries: xyValues, label: "为什么啊")
//        // 是可以支持多个集合数据的
//        let chartData = BarChartData(dataSets: [dataSet])
//        
//        self.chartView.data = chartData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BillBarChartView: ChartViewDelegate {
    // TODO: Cannot override from extensions
    //extension DemoBaseViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}


#Preview {
    let contentView = UIView()
    let firstView = BillBarChartView()
    firstView.frame = CGRectMake(0, 150, ScreenConst.width,500.fitScale())
    contentView.addSubview(firstView)
    
//    firstView.configChartData(data: ["1","2"])
    
    return contentView
}
