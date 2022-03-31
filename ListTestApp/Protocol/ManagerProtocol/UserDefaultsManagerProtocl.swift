//
//  UserDefaultsManagerProtocl.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation


protocol UserDefaultsManagerProtocl{
    
    var favoriteList : Accommodations { get set }
    
    
    func favoriteCheck(accommodation : Accommodation) -> FavoriteChecking
    
    mutating func favoriteAddDelete(accommodation : Accommodation)
    
    mutating func clearRemoveList()
}

extension UserDefaultsManagerProtocl {
   
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
