//
//  SortTypeSettingView.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//
import UIKit
import SnapKit
import Then

protocol BottomSheetItemSettingProtocol {
    var sortTypeViewArray : [SortTypeStackView] { get set }
    
    func bottomSheetItemSetting()
    func sortTypeSetting(type : SortType)
}

class SortTypeSettingView : BottomSheetView , BottomSheetItemSettingProtocol {
    
    
    //UI
    lazy var mainKeyword = UILabel().then{
        $0.numberOfLines = 1
        $0.textColor = .primaryColor
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.text = "정렬"
    }
    
    var recentFavorite = SortTypeStackView(item : .RecentFavorite).then{
        $0.typeLabel.text =  "최근 즐겨찾기 등록순"
        $0.unSelecteSetting()
    }
    var lateFavorite = SortTypeStackView(item : .LateFavorite).then{
        $0.typeLabel.text =  "늦은 즐겨찾기 등록순"
        $0.unSelecteSetting()
    }
    var highestPrice = SortTypeStackView(item : .HighestPrice).then{
        $0.typeLabel.text =  "높은 가격순"
        $0.unSelecteSetting()
    }
    var lowPrice = SortTypeStackView(item : .LowPrice).then{
        $0.typeLabel.text =  "낮은 가격순"
        $0.unSelecteSetting()
    }
    var highestRating = SortTypeStackView(item : .HighestRating).then{
        $0.typeLabel.text =  "높은 평점순"
        $0.unSelecteSetting()
    }
    var lowRating = SortTypeStackView(item : .LowRating).then{
        $0.typeLabel.text =  "낮은 평점순"
        $0.unSelecteSetting()
    }
  
    
    //Other
    lazy var sortTypeViewArray = [recentFavorite,lateFavorite,highestPrice,lowPrice,highestRating,lowRating]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomSheetItemSetting()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bottomSheetItemSetting()
    }
    
    func bottomSheetItemSetting(){
        bottomSheetView.addArrangedSubview(mainKeyword)
        sortTypeViewArray.forEach{ [weak self] in
            guard let self = self else { return }
            self.bottomSheetView.addArrangedSubview($0)
        }
        
    }
    
}


extension BottomSheetItemSettingProtocol {
    func sortTypeSetting(type : SortType){
        sortTypeViewArray.forEach{
            if($0.item == type){
                $0.selectSetting()
            }else{
                $0.unSelecteSetting()
            }
        }
    }
}
