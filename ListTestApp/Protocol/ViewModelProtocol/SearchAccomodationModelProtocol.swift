//
//  SearchAccomodationModelProtocol.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation
import RxSwift

protocol SearchAccomodationModelProtocol{
    func searchAccomodation(page : Int , networkAPI : NetworkServiceProtocol) -> Single<AccommodationResModel>
}

extension SearchAccomodationModelProtocol{
    func searchAccomodation(page : Int , networkAPI : NetworkServiceProtocol) -> Single<AccommodationResModel>{
        networkAPI
            .request(type: AccommodationResModel.self, .search(page: page))
        
    }
}
