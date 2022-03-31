//
//  Model_Extension.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import Foundation

extension Accommodations {
    
    func sortAction(sortType : SortType , userManager : UserDefaultsManagerProtocl) -> Accommodations{
        switch sortType {
        case .RecommendedOrder:
            return  self.sorted{ $0.id < $1.id }
        case .HighestRating:
            return  self.sorted{ $0.rate > $1.rate }
        case .LowRating:
            return  self.sorted{ $0.rate < $1.rate }
        case .HighestPrice:
            return  self.sorted{ $0.description.price > $1.description.price }
        case .LowPrice:
            return  self.sorted{ $0.description.price < $1.description.price }
        //CoreData에 데이터 형식을 만들어서 사용할려고 고민했지만
        //내부에서 저장하는값 + 등록한 날짜가 필요하지 않기에
        //등록한 ArrayList에서 순서대로 꺼내오는 형식을 선택함
        //추후의 확장성을 생각한다면 CoreData로 추가 날짜 , 아이템을 저장하는것도 좋지만
        //과제의 특성상 이렇게 대체
        case .RecentFavorite :
            return userManager.favoriteList
        case .LateFavorite :
            return userManager.favoriteList.reversed()
        }
        
    }
    
    
}
