//
//  AccommodationSectionModel.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import RxDataSources

struct AccommodationSectionModel {
    let name : String
    var items : Accommodations
}

extension AccommodationSectionModel : AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = Accommodation
    
    var identity: String {
        return name
    }
    
    
    init(original: AccommodationSectionModel , items: Accommodations) {
        self = original
        self.items = items
    }
}

extension AccommodationSectionModel {
    func itemSort(sortType : SortType , userManager : UserDefaultsManagerProtocl) -> AccommodationSectionModel {
        return AccommodationSectionModel(name: self.name, items: self.items.sortAction(sortType: sortType , userManager : userManager))
    }
    
}
 
