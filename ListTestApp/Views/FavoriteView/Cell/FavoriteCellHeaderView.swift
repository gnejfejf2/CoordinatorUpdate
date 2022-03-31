//
//  FavoriteCellHeaderView.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import UIKit
import Then
import SnapKit

protocol HeaderActionProtocol : AnyObject {
    func headerAction()
    
}



class FavoriteCellHeaderView : UICollectionReusableView  {
   
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    lazy var stackView = UIStackView().then{
        $0.backgroundColor = .primaryColorReverse
        $0.alignment = .center
        $0.distribution = .fill

        $0.addArrangedSubview(sortTypeButton)
    }
    

    let sortTypeButton = UIButton().then{
        $0.setTitle("정렬", for: .normal)
        $0.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        $0.tintColor = .primaryColor
        $0.setTitleColor(.primaryColor, for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
  
    weak var delegate : HeaderActionProtocol?
    
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
        
      
        
        sortTypeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sortSheetOpen)))
    }
    
    
    @objc func sortSheetOpen(){
        delegate?.headerAction()
    }
}
