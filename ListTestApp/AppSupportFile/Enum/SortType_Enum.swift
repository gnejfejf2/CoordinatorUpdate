//
//  SortType_Enum.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import Foundation

enum SortType{
    ///추천순
    case RecommendedOrder
    ///평점높은순
    case HighestRating
    ///평점낮은순
    case LowRating
    ///가격높은순
    case HighestPrice
    ///가격낮은순
    case LowPrice
    ///즐겨찾기 빠른 등록순
    case RecentFavorite
    ///즐겨찾기 늦은 등록순
    case LateFavorite
}

