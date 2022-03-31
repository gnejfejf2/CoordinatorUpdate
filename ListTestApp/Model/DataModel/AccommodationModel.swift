import Foundation
import RxDataSources
// MARK: - Product
struct Accommodation: Codable  , IdentifiableType{
    typealias Identity = String

    
    
    var identity : Identity = UUID().uuidString
    
    let id: Int
    let name: String
    let thumbnail: String
    let description: AccommodationDescription
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail
        case description
        case rate
    }
}


// MARK: - Description
struct AccommodationDescription: Codable {
    let imagePath: String
    let subject: String
    let price: Int
}

extension Accommodation :  Equatable{
    static func == (lhs: Accommodation, rhs: Accommodation) -> Bool {
        return lhs.id == rhs.id
    }
}


typealias Accommodations = [Accommodation]
