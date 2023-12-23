//
//  DragTableViewController.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/19.
//

import UIKit

class DragTableViewController: UIViewController {

    var datas: [[String]] = []
    var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datas = [
            ["床前明月光",
            "疑是地上霜",
            "举头望明月",
            "低头思故乡",],
            
            ["1",
            "2",
            "3",],
        ]
        
        tableview = UITableView.init(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .insetGrouped)
        tableview.delegate = self
        tableview.dataSource = self
        // MARK: 有两种实现拖动的方式，一种是通过dragInteractionEnabled = true，这样就不需要再isEditing的状态下也能进行拖动。
        // 拖动部分
        tableview.dragInteractionEnabled = false
        tableview.dragDelegate = self
        tableview.dropDelegate = self
        // 其实可以不使用这个。 一般弄个按钮点击来控制编辑状态。
        tableview.isEditing = true
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableview)
 
    }
}

extension DragTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = datas[indexPath.section][indexPath.row]
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = "这是\(section)分区"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
        
}


extension DragTableViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //    UITableViewCellEditingStyleNone 没有编辑样式
    //    UITableViewCellEditingStyleDelete 删除样式 （左边是红色减号）
    //    UITableViewCellEditingStyleInsert 插入样式  (左边是绿色加号)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    // 编辑模式下，不让cell缩进，要怎么做呢？ 配合上面的.none使用
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (action, view, handler) in
            debugPrint("delete")
            self.datas[indexPath.section].remove(at: indexPath.row)
//            self.datas.remove(at: indexPath.row)
            self.tableview.reloadData()
        }
        let editAction = UIContextualAction(style: .normal, title: "编辑") { action, view, handler in
            debugPrint("edit")
            
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// 拖动
extension DragTableViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = datas[indexPath.section][indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = datas[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        datas[destinationIndexPath.section].insert(mover, at: destinationIndexPath.row)
    }
}


#Preview {
    let vc = DragTableViewController()
    return vc
}
