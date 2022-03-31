//
//  UserDefaultsManagerProtocl.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation


protocol UserDefaultsManagerProtocol{
    
    var favoriteList : Accommodations { get set }
    
    func getFavoriteList() -> Accommodations
    
    func favoriteCheck(accommodation : Accommodation) -> FavoriteChecking
    
    mutating func favoriteAddDelete(accommodation : Accommodation)
    
    mutating func clearRemoveList()
}

extension UserDefaultsManagerProtocol {
   // getFavoriteList 을 함수로 만들어 접근시킨이유
    //추후에 Core데이터로 변경시 이 함수 하나만을 수정하여 Accommodations를 리턴시키면 많은 곳을 수정할 필요가 없음
    
    func getFavoriteList() -> Accommodations{
        
        return favoriteList
    }
    
    func favoriteCheck(accommodation : Accommodation) -> FavoriteChecking{
        if let _ = favoriteList.firstIndex(of: accommodation) {
            return .Check
        }else{
            return .UnCheck
        }
    }
    
    mutating func favoriteAddDelete(accommodation: Accommodation) {
        if let index = favoriteList.firstIndex(of: accommodation) {
            self.favoriteList.remove(at: index)
        }else{
            self.favoriteList.append(accommodation)
        }
    }
    
    mutating func clearRemoveList(){
        self.favoriteList.removeAll()
    }
}
