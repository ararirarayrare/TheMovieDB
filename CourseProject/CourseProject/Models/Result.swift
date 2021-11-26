import Foundation

struct Result : Codable {
    let genreIds : [Int]?
    let id : Int?
    let originalTitle: String?
    let originalName: String?
    let title: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case id = "id"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case title = "title"
        case posterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
    }
}
