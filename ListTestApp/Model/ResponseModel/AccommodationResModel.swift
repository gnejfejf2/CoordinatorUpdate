//
//  AccommodationResModel.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation
// MARK: - Welcome
struct AccommodationResModel: Codable {
    let msg: String
    let data: DataClass
    let code: Int
}

// MARK: - DataClass
struct DataClass: Codable {
    let totalCount: Int
    let product: Accommodations
}


