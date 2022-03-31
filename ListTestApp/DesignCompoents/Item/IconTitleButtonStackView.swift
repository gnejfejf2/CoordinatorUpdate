//
//  IconTitleButtonStackView.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import UIKit

class IconTitleButton : UIStackView , ComponentSettingProtocol {
    
    var mainImageView = UIImageView().then{
        $0.image = UIImage(systemName: "star.fill")
        $0.tintColor = .yellow
    }
    
    var mainTitleLabel = UILabel()
    
    
    let mainButton = UIButton().then{
        $0.setImage(UIImage(named: "forward_black")?.withRenderingMode(.alwaysTemplate) , for: .normal)
        $0.imageView?.tintColor = .placeholderText
        $0.setTitleColor(.accentColor, for: .normal)
        $0.contentHorizontalAlignment = .leading
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiSetting()
    }
   
   
    
    func uiSetting() {
        backgroundColor = .primaryColorReverse
        axis = .horizontal
        spacing = 8
        distribution = .fill
        
        
        addArrangedSubview(mainImageView)
        addArrangedSubview(mainTitleLabel)
        addArrangedSubview(mainButton)
    }
   
}
