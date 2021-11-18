import Foundation

struct TvSeasons : Codable {
    let air_date : String?
    let episode_count : Int?
    let id : Int?
    let name : String?
    let overview : String?
    let poster_path : String?
    let season_number : Int?
    
    enum CodingKeys: String, CodingKey {
        case air_date = "air_date"
        case episode_count = "episode_count"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case poster_path = "poster_path"
        case season_number = "season_number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        air_date = try values.decodeIfPresent(String.self, forKey: .air_date)
        episode_count = try values.decodeIfPresent(Int.self, forKey: .episode_count)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        season_number = try values.decodeIfPresent(Int.self, forKey: .season_number)
    }
}
