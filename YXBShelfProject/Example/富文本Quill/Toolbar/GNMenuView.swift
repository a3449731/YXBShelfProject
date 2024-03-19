//
//  GNMenuView.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/1/30.
//

import UIKit

/**
  @berif 这整个就是 点击更多按钮 弹出的更多菜单。 目前有拍照，选择照片，和选择文件。
 */

protocol GNMenuViewDelegate: NSObjectProtocol {
    func menuView(_ menu: GNMenuView, didSelect item: GNMenuItemType)
}

class GNMenuView: UIView {
    
    weak var delegate: GNMenuViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: 108, height: 129)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GNMenuItemCell.self, forCellWithReuseIdentifier: "GNMenuItemCell")
        return collectionView
    }()
    
    let modelArray: [GNMenuItemType] = GNMenuItemType.allCases
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
        self.collectionView.reloadData()
    }
    
    private func creatUI() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GNMenuView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.modelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.modelArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GNMenuItemCell", for: indexPath) as! GNMenuItemCell
        cell.setup(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.modelArray[indexPath.row]
        self.delegate?.menuView(self, didSelect: model)
    }
}

// MARK: -model
enum GNMenuItemType: CaseIterable {
    case picture
    case takePhoto
    case file
    
    func localString() -> String {
        switch self {
        case .picture: return "图片"
        case .takePhoto: return "拍照"
        case .file: return "文件"
        }
    }
    
    func icon() -> UIImage? {
        switch self {
        case .picture: return UIImage(named: "gn_list_check")
        case .takePhoto: return UIImage(named: "gn_list_check")
        case .file: return UIImage(named: "gn_list_check")
        }
    }
}

// MARK: -cell
class GNMenuItemCell: UICollectionViewCell {
    private let iconImgView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImgView)
        contentView.addSubview(nameLabel)
        
        iconImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImgView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func setup(model: GNMenuItemType) {
        iconImgView.image = model.icon()
        nameLabel.text = model.localString()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
