//
//  RentalTypeStackView.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation
import UIKit
import Then
import RxSwift
import SnapKit

class RentalTypeStackView : UIStackView , ComponentSettingProtocol {
    
    
    var typeLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .placeholderText
        $0.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
    }
   
    var priceLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .primaryColor
        $0.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
    }
    
    var devideView = UIView().then{
        $0.backgroundColor = .placeholderText
        $0.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
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
        axis = .horizontal
        distribution = .fill
        addArrangedSubview(typeLabel)
        addArrangedSubview(priceLabel)
    }
    
    func itemSetting(type : String = "대실 ∙ 프리미엄룸 (넷플릭스)" , price : Int){
        typeLabel.text = type
        
        priceLabel.text = "\(price)원"
        
        let text = priceLabel.text!
        let attrStr = NSMutableAttributedString(string: text)
        
        attrStr.addAttribute(.foregroundColor, value: UIColor.primaryColor.withAlphaComponent(0.9) , range: (text as NSString).range(of: "원"))
        attrStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .light) , range: (text as NSString).range(of: "원"))
        priceLabel.attributedText = attrStr
        
    }
    
  
}
