//
//  TopInformationView.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import Foundation
import UIKit

class TopInformationView : UIStackView , ComponentSettingProtocol {
    
    var titleLalel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .primaryColor
    }
   
    var placeLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .primaryColor
    }
    
    var mapStackView = IconTitleButton().then{
        $0.mainImageView.image = UIImage(systemName: "arrowtriangle.down.circle")
        $0.mainImageView.tintColor = .accentColor
        
        $0.mainTitleLabel.font = UIFont.systemFont(ofSize: 14)
        $0.mainTitleLabel.textColor = .primaryColor
        
        $0.mainButton.setTitle("지도보기", for: .normal)
    }
  
   
    var rateStackView = IconTitleButton().then{
        $0.mainImageView.image = UIImage(systemName: "star.fill")
        $0.mainImageView.tintColor = .yellow
        $0.mainImageView.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        
        
        $0.mainTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.mainTitleLabel.textColor = .placeholderText
        
        $0.mainButton.setTitle("리뷰 4,887개 보기", for: .normal)
    }
    
   
   
    var item : Accommodation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiSetting()
    }
   
    convenience init(item : Accommodation) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.item = item
    }
    
    
    func uiSetting() {
        backgroundColor = .primaryColorReverse
        axis = .vertical
        spacing = 12
        distribution = .fill
        alignment = .leading
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        addArrangedSubview(titleLalel)
        addArrangedSubview(placeLabel)
        addArrangedSubview(mapStackView)
        addArrangedSubview(rateStackView)
    }
   
    func itemSetting(item : Accommodation){
        self.item = item
        
        titleLalel.text = item.name
        mapStackView.mainTitleLabel.text = "경기 수원시 영통구 영통동 1010-11"
        rateStackView.mainTitleLabel.text = "\(item.rate)"
        
    }
    
  
}
