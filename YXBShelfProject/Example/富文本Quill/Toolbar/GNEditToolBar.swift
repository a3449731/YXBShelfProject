//
//  EditToolBar.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/1/22.
//

import UIKit

protocol GNEditToolBarDelegate: NSObjectProtocol {
    func blur(_ toolBar: GNEditToolBar);
    func editToolBar(_ toolBar: GNEditToolBar, action: String, val: Any?)
}

class GNEditToolBar: UIView, UIScrollViewDelegate {
    
    weak var delegate: GNEditToolBarDelegate?
    
    var barItems: NSArray = []
    var barButtons: NSMutableArray = []
    var barItemsIndex: Dictionary<String, Int> = [:]
        
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
//        stackView.spacing = self.spacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        loadConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        layer.shadowColor = UIColor.backgroundColor_gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowOpacity = 0.8
        backgroundColor = UIColor.white
        
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    func loadConfiguration() {
        guard let path = Bundle.main.path(forResource: "EditAction", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do{
            let data = try Data(contentsOf: url)
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            barItems = jsonData as! NSArray
            setupSubViews()
        }catch let error as Error? {
            debugPrint("Error reading local data!",error ?? "")
        }
    }
    
    func setupSubViews() {
        
        let itemSpace: CGFloat = 6
        let itemWidth: CGFloat = 44
        let width = self.frame.size.width
        var maxX: CGFloat = 0;
        
//        let container = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: width - itemWidth, height: itemWidth))
//        container.showsHorizontalScrollIndicator = false
//        container.delegate = self
//        addSubview(container)
        
        let closeButton = EditButton.init(frame: CGRect(x: width - itemWidth, y: 0, width: itemWidth, height: itemWidth))
        closeButton.action = "close"
        closeButton.addTarget(self, action: #selector(blur), for: .touchUpInside)
        closeButton.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        closeButton.setImage(UIImage(named: "gn_list_check"), for: .normal)
        addSubview(closeButton)
     
        for (index, item) in barItems.enumerated() {
            if let _item = item as? Dictionary<String, String> {
                let itemButton = EditButton.init(frame: CGRect(x: (itemSpace + itemWidth) * CGFloat(index) + itemSpace, y: 0, width: itemWidth, height: itemWidth))
                itemButton.tag = index
                itemButton.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                itemButton.setImage(UIImage(named: _item["image"]!), for: .normal)
                itemButton.setImage(UIImage(named: _item["selectImage"]!), for: .selected)
                itemButton.action = _item["action"]
                itemButton.addTarget(self, action: #selector(operation(_:)), for: .touchUpInside)
//                container.addSubview(itemButton)
                hStack.addArrangedSubview(itemButton)
                maxX = itemButton.frame.maxX
                barButtons.add(itemButton)
                barItemsIndex[_item["action"]!] = index
            }
        }
        hStack.addArrangedSubview(closeButton)
        debugPrint("maxY: ", maxX);
//        container.contentSize = CGSize.init(width: maxX + itemSpace, height: itemWidth)
    }
    
    @objc func blur() {
        if let _delegate = delegate {
            _delegate.blur(self)
        }
    }
    
    
    /// On Click
    ///
    /// - Parameter item: item
    @objc func operation(_ item: EditButton){
        item.isSelected = !item.isSelected

        if let _delegate = delegate {
            if item.action == "background" || item.action == "color" {
                _delegate.editToolBar(self, action: item.action ?? "", val: item.isSelected)
            } else if item.action == "size" {
                _delegate.editToolBar(self, action: item.action ?? "", val: item.isSelected)
            } else{
                _delegate.editToolBar(self, action: item.action ?? "", val: item.isSelected)
            }
        }
    }
    
    
    /// Update the status of the button
    ///
    /// - Parameter params: Update parameters on the js
    func updateButtonItemStatus(_ params: Dictionary<String, Any>) {
        barButtons.forEach { (item) in
            if let _item = item as? UIButton {
                _item.isSelected = false
            }
        }
        
        for key in params.keys {
            var index = 0;
            if key == "list" ||  key == "align" || key == "script" {
                if let val = params[key] as? String {
                    index = barItemsIndex[val] ?? 0
                }
            }else {
                if let _index = barItemsIndex[key] {
                    index = _index;
                }
            }
            
            if let barItem = barButtons[index] as? UIButton {
                barItem.isSelected = true
            }
        }
    }
}


class EditButton: UIButton {
    var action: String?
}
