//
//  CalendarViewController.swift
//  YXBShelfProject
//
//  Created by yang on 2024/3/24.
//


import UIKit
import JXSegmentedView
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    private var calendarView: GXWCalendarView?
    private var tableView: UITableView?
    private let titles = ["待开始", "已结束"]
    private var courseTimesLabel: UILabel?
    private lazy var segmentedView = creatSegmentedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        setupUI()
        setupTool()
        setupData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        creatCalendar()
        creatTableView()
    }
    
    private func setupTool() {
        // Add setup tool code here
    }
    
    private func setupData() {
        requestCalendarEventData()
    }
    
    func requestCalendarEventData() {
        // Add request calendar event data code here
    }
    
    // MARK: - UITableView
    func creatTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = self.view.backgroundColor
        self.tableView?.keyboardDismissMode = .onDrag
        self.tableView?.estimatedRowHeight = 164
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        if #available(iOS 15.0, *) {
            self.tableView?.sectionHeaderTopPadding = 0
        }
        
        guard let tableView = self.tableView else { return }
        self.view.addSubview(tableView)
        self.tableView?.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    deinit {
        debugPrint(self.className + " deinit 🍺")
    }
    
    
}

// MARK: - GXWCalendarViewDelegate 日历
extension CalendarViewController: GXWCalendarViewDelegate {
    
    func creatCalendar() {
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 450 : 300
   //        let frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: height)
        self.calendarView = GXWCalendarView(frame: .zero)
        self.calendarView?.delegate = self
        guard let calendarView = self.calendarView else { return }
        self.view.addSubview(calendarView)
        
        self.calendarView?.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    // 日历发生了翻页,需要去请求事件数据，这地方看后台怎么给吧。如果后台是全部给，就不用请求。要是只给一个月的，那翻页时就要请求了
    func calendarCurrentPageDidChange(_ calendar: GXWCalendarView) {
        
    }
    
    // 点击之后要请求当天的课程表。
    func calendar(_ calendar: GXWCalendarView, didSelectDate date: Date, atMonthPosition monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: GXWCalendarView, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
    }
    
    func calendar(_ calendar: GXWCalendarView, willDisplayCell cell: FSCalendarCell, forDate date: Date, atMonthPosition monthPosition: FSCalendarMonthPosition) {
        
    }
}


// MARK: - 与这个类没关系，临时写在这的 JXSegmentedListContainerViewDataSource 分页的控制器的回调
extension CalendarViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    
    func creatSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        
        // 配置数据源相关配置属性
        let segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = self.titles
        segmentedDataSource.titleSelectedFont = .titleFont_14
        segmentedDataSource.titleSelectedColor = .titleColor
        segmentedDataSource.titleNormalFont = .titleFont_14
        segmentedDataSource.titleNormalColor = .subTitleColor
        segmentedDataSource.isItemSpacingAverageEnabled = true
        //        segmentedDataSource.itemSpacing = 24
        segmentedDataSource.isTitleColorGradientEnabled = true
        // 关联dataSource
        segmentedView.dataSource = segmentedDataSource
        segmentedView.defaultSelectedIndex = 0
        
        //  - 内容试图的绑定
        let listContainerView = JXSegmentedListContainerView(dataSource: self)
        // 禁止滑动，只能点击
        //        listContainerView.scrollView.isScrollEnabled = false
        self.view.addSubview(listContainerView)
        //关联listContainer
        segmentedView.listContainer = listContainerView
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ScreenConst.bottomSpaceHeight - 50.fitScale())
        }
        
        //  - 初始化指示器indicator
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 10
        indicator.indicatorHeight = 3
        indicator.indicatorColor = .indicatorColor_black
        indicator.indicatorPosition = .bottom
        segmentedView.indicators = [indicator]
        
        return segmentedView
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        let dataSource = self.segmentedView.dataSource as? JXSegmentedTitleDataSource
        return dataSource?.titles.count ?? 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = MSDressCenterVC()
        return vc
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
}
