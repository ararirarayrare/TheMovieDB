import Foundation

struct TvSeasons : Codable {
	let airDate : String?
	let episodeCount : Int?
	let id : Int?
	let name : String?
	let overview : String?
	let posterPath : String?
	let seasonNumber : Int?

	enum CodingKeys: String, CodingKey {
		case airDate = "air_date"
		case episodeCount = "episode_count"
		case id = "id"
		case name = "name"
		case overview = "overview"
		case posterPath = "poster_path"
		case seasonNumber = "season_number"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        airDate = try values.decodeIfPresent(String.self, forKey: .airDate)
        episodeCount = try values.decodeIfPresent(Int.self, forKey: .episodeCount)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        seasonNumber = try values.decodeIfPresent(Int.self, forKey: .seasonNumber)
	}
}
