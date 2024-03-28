//
//  GXWCalendarView.swift
//  YXBShelfProject
//
//  Created by yang on 2024/3/24.
//

import UIKit
import FSCalendar

/// 课程表日历的代理，主要是为点击事件，滑动事件给外界留的接口。
@objc protocol GXWCalendarViewDelegate: AnyObject {
    /// 点击了某个cell的回调
    func calendar(_ calendar: GXWCalendarView, didSelectDate date: Date, atMonthPosition monthPosition: FSCalendarMonthPosition)
    /// 日历的frame将要发生改变
    func calendar(_ calendar: GXWCalendarView, boundingRectWillChange bounds: CGRect, animated: Bool)
    /// cell即将展示出来，可以在这里对元素做一些调整
    func calendar(_ calendar: GXWCalendarView, willDisplayCell cell: FSCalendarCell, forDate date: Date, atMonthPosition monthPosition: FSCalendarMonthPosition)
    /// 历的月份或者周份发生了改变
    func calendarCurrentPageDidChange(_ calendar: GXWCalendarView)
}

/*
 *  @brief 包装的日历view，在这里能够更好的看清楚FSCalendar是怎么使用的
 */
class GXWCalendarView: UIView {
    
    weak var delegate: GXWCalendarViewDelegate?
    // 日历组件
    private var calendar: FSCalendar!
    private var gregorian: Calendar!
    private var dateFormatter: DateFormatter!
    // 展示月份的按钮
    private var monthButton: UIButton!
    // 今天按钮
    private var todayButton: UIButton!
    // 日历下方的横线图片
    private var lineImageView: UIImageView!
    
    // 数据源，那些日子存在课程事件
    private var modelArray: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gregorian = Calendar(identifier: .gregorian)
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        creatCalendar()
    }
    
    private func creatCalendar() {
        calendar = FSCalendar(frame: .zero)
        calendar.backgroundColor = .white
        calendar.layer.cornerRadius = 5
        calendar.layer.masksToBounds = true
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsSelection = true
        calendar.today = nil
        calendar.register(GXWCalendarCell.self, forCellReuseIdentifier: "GXWCalendarCell")
        
        // 这些配置都可透过代理为每一条数据做差异化展示
        // 普通字体颜色
        calendar.appearance.titleDefaultColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)
        // 选中字体颜色
        calendar.appearance.titleSelectionColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)
        // 今天的字体颜色
        calendar.appearance.titleTodayColor = UIColor(red: 243/255, green: 53/255, blue: 45/255, alpha: 1)
        // 非本月日子的字体颜色
        calendar.appearance.titlePlaceholderColor = UIColor(red: 188/255, green: 195/255, blue: 206/255, alpha: 1)
        // 选中的背景色
        calendar.appearance.selectionColor = .white
        // 日子的字体
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 15)
        // 事件小圆点的颜色
        calendar.appearance.eventDefaultColor = UIColor(red: 243/255, green: 53/255, blue: 45/255, alpha: 1)
        calendar.appearance.eventSelectionColor = UIColor(red: 243/255, green: 53/255, blue: 45/255, alpha: 1)
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        // 设置周次是中文显示
        calendar.locale = Locale(identifier: "zh_CN")
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        // 周的字体颜色
        calendar.appearance.weekdayFont = UIFont.pingFang(fontSize: 14)
        calendar.appearance.weekdayTextColor = UIColor(red: 188/255, green: 195/255, blue: 206/255, alpha: 1)
        // 展示月份头部的高度
        calendar.headerHeight = 43
        // 这部分为了适配UI图用按钮替代了。就给个白色先不展示出来吧
        calendar.appearance.headerDateFormat = "yyyy - MM "
        calendar.appearance.headerTitleColor = UIColor.white
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 15)
        addSubview(calendar)
        
        // 用来撑起父试图的布局
        calendar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(300)
        }
        // 设置默认选中为今天。
        calendar.select(Date())
        
        // 平移的手势，可以让日历展开和收起，实现在calendar里handleScopeGesture。
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(FSCalendar.handleScopeGesture(_:)))
        addGestureRecognizer(scopeGesture)
        
        // 展示月份和年
        monthButton = UIButton(type: .custom)
        monthButton.backgroundColor = .white
        monthButton.layer.cornerRadius = 5
        addSubview(monthButton)
        updateMonthButtonWithDate(date: Date())
        monthButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.calendarHeaderView).offset(1)
            make.left.equalTo(calendar.calendarHeaderView)
            make.bottom.equalTo(calendar.calendarHeaderView).offset(-1)
            make.width.equalTo(calendar.calendarHeaderView).multipliedBy(0.3)
        }
        
        // 展示今天，只有在非选中今天时才展示
        todayButton = UIButton(type: .system)
        todayButton.isHidden = true
        todayButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 17)
        todayButton.contentHorizontalAlignment = .right
        todayButton.backgroundColor = .white
        todayButton.layer.cornerRadius = 5
        todayButton.titleLabel?.font = .pingFang(fontSize: 13)
        todayButton.setTitleColor(UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1), for: .normal)
        todayButton.setTitle("今天", for: .normal)
        todayButton.addTarget(self, action: #selector(todayComeBack), for: .touchUpInside)
        addSubview(todayButton)
        todayButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.calendarHeaderView).offset(1)
            make.right.equalTo(calendar.calendarHeaderView)
            make.bottom.equalTo(calendar.calendarHeaderView).offset(-1)
            make.width.equalTo(calendar.calendarHeaderView).multipliedBy(0.3)
        }
        
        lineImageView = UIImageView()
        lineImageView.image = UIImage(named: "CUYuYinFang_fanzhuHead")
        addSubview(lineImageView)
        lineImageView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.centerX.equalTo(calendar)
            make.width.equalTo(23)
            make.height.equalTo(10)
        }
    }
    
    // 回到今天，点击了今天按钮触发。
    @objc private func todayComeBack() {
        calendar.select(Date(), scrollToDate: true)
        calendar.reloadData()
        todayButton.isHidden = !shouldShowTodayButton()
    }
    
    // MARK: 今天
    // 用于判断是否展示today的按钮.不在当前月份的时候要展示。 在当前月份需要再判断是否选中的是否为今天。
    private func shouldShowTodayButton() -> Bool {
        let currentMonth = calendar.currentPage.month == Date().month
        if !currentMonth {
            return true
        } else {
            let isToday = gregorian.isDateInToday(calendar.selectedDate ?? Date(timeIntervalSince1970: 1))
            return !isToday
        }
    }
    
    // 更新月份信息
    private func updateMonthButtonWithDate(date: Date) {
        let month = gregorian.component(.month, from: date)
        let year = gregorian.component(.year, from: date)
        let att = NSMutableAttributedString()
        let monthAtt = NSMutableAttributedString(string: "\(month)月 ", attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)])
        att.append(monthAtt)
        let yearAtt = NSMutableAttributedString(string: "\(year) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor(red: 136/255, green: 147/255, blue: 165/255, alpha: 1)])
        att.append(yearAtt)
        monthButton.setAttributedTitle(att, for: .normal)
    }
    
    // MARK: - 数据源
    func reloadWithEventArray(eventArray: [String]) {
        modelArray = eventArray
        calendar.reloadData()
    }
}

// MARK: - 日历代理 FSCalendarDelegate
extension GXWCalendarView: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // 最小能选的日期，两年前
    func minimumDate(for calendar: FSCalendar) -> Date {
        return gregorian.date(byAdding: .month, value: -24, to: Date()) ?? Date()
    }
    
    // 最多能选的日期，两年后
    func maximumDate(for calendar: FSCalendar) -> Date {
        return gregorian.date(byAdding: .month, value: 24, to: Date()) ?? Date()
    }
    
    // 设置日历展示的文字
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if gregorian.isDateInToday(date) {
            return "今"
        }
        return nil
    }
    
    // 默认的字体色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if gregorian.isDateInToday(date) {
            return UIColor(hex: 0xF3352D)
        }
        return nil
    }
    
    // 选中的字体色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if gregorian.isDateInToday(date) {
            return UIColor(hex: 0xF3352D)
        }
        return nil
    }
    
    // 设置事件小圆点的颜色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let daysBofore = daysBetweenDate(fromDateTime: Date(), andDate: date)
        if daysBofore < 0 {
            return [calendar.appearance.titlePlaceholderColor]
        } else {
            return nil
        }
    }
    
    // 天数比较
    //    private func daysBetweenDates(_ date1: Date, _ date2: Date) -> Int {
    //        let calendar = Calendar.current
    //        let components = calendar.dateComponents([.day], from: date1, to: date2)
    //        return abs(components.day ?? 0)
    //    }
    
    func daysBetweenDate(fromDateTime: Date, andDate toDateTime: Date) -> Int {
        let calendar = Calendar.current
        
        // 将日期规范化为午夜时刻
        let fromDateComponents = calendar.dateComponents([.year, .month, .day], from: fromDateTime)
        let fromDate = calendar.date(from: fromDateComponents)
        
        let toDateComponents = calendar.dateComponents([.year, .month, .day], from: toDateTime)
        let toDate = calendar.date(from: toDateComponents)
        
        let difference = calendar.dateComponents([.day], from: fromDate!, to: toDate!)
        
        return difference.day!
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return nil
    }
    
    // 选中的填充色，在初始化的时候渲染数据的时候决定好了
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return nil
    }
    
    // 默认的填充色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return nil
    }
    
    // MARK: 调整日历内部元素的位置，字体设置
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 把小圆点调整到右上角
        calendar.appearance.eventOffset = CGPoint(x: cell.contentView.bounds.size.width / 4, y: -(cell.contentView.bounds.size.height * 0.7))
        cell.contentView.sendSubviewToBack(cell.imageView)
        //    calendar.appearance.titleOffset = CGPoint(x: 0, y: cell.contentView.bounds.size.height / 12)
        if calendar.selectedDate == date {
            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            cell.titleLabel.font = UIFont.systemFont(ofSize: 15)
        }
        
        // 留给外界的接口
        self.delegate?.calendar(self, willDisplayCell: cell, forDate: date, atMonthPosition: monthPosition)
    }
    
    // MARK: 自定义的cell，倒也可以不用自定义，FSCalendar本身已经很强大了
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "GXWCalendarCell", for: date, at: position) as! GXWCalendarCell
        if calendar.selectedDate == date {
            cell.hasSelect = true
        } else {
            cell.hasSelect = false
        }
        return cell
    }
    
    // MARK: 设置事件的数量
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let beforeDate = gregorian.date(byAdding: .day, value: -22, to: Date()) ?? Date()
        let behindDate = gregorian.date(byAdding: .day, value: 10, to: Date()) ?? Date()
        if dateFormatter.string(from: beforeDate) == dateFormatter.string(from: date) || dateFormatter.string(from: behindDate) == dateFormatter.string(from: date) {
            return 1
        }
        if gregorian.isDateInToday(date) {
            return 1
        }
        return 0
    }
    
    // MARK: 设置是否可以点击cell。 目前不允许:占位的非本月日期点击
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at position: FSCalendarMonthPosition) -> Bool {
        return position == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at position: FSCalendarMonthPosition) -> Bool {
        return position == .current
    }
    
    // MARK: cell点击事件: 点击日历的某一天
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at position: FSCalendarMonthPosition) {
        calendar.visibleCells().forEach { cell in
            if let selectCell = cell as? GXWCalendarCell {
                selectCell.hasSelect = false
            }
        }
        
        if let selectCell = calendar.cell(for: date, at: position) as? GXWCalendarCell {
            selectCell.hasSelect = true
        }
        
        todayButton.isHidden = !shouldShowTodayButton()
        
        delegate?.calendar(self, didSelectDate: date, atMonthPosition: position)
    }
    
    // MARK: 日历当前页面改变
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage
        updateMonthButtonWithDate(date: date)
        todayButton.isHidden = !shouldShowTodayButton()
        
        // 留给外界的接口
        delegate?.calendarCurrentPageDidChange(self)
    }
    
    // MARK: 需要配合着平移手势scopeGesture对日历进行展开折叠使用
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
        
        // 关闭掉隐士动画，不然效果很奇怪
        CATransaction.setDisableActions(true)
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.size.height)
        }
        layoutIfNeeded()
        CATransaction.commit()
        
        lineImageView.frame = CGRect(x: calendar.frame.midX - 11.5, y: calendar.frame.maxY, width: 23, height: 10)
        // 留给外界的接口
        delegate?.calendar(self, boundingRectWillChange: bounds, animated: animated)
    }
}

//// MARK: 监听滑动，是为了和tableView联动做的准备。如果不需要与tableview联动，真的不用监听这玩意
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if (context == _KVOContext) {
//        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
//        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
//        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
