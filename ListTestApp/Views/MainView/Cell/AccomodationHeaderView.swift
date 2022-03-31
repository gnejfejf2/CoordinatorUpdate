//
//  HeaderView.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation
import UIKit
import UIKit
import SnapKit
class AccomodationHeaderView : UICollectionReusableView , CellSettingProtocl {
   
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    lazy var stackView = UIStackView().then{
        $0.backgroundColor = .primaryColorReverse
        $0.addArrangedSubview(label)
    }
    let label = BasePaddingLabelView().then{
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor
    }
    
  
    var item : String?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       uiSetting()
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func uiSetting() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func itemSetting(item: String) {
        label.text = item
    }
}
