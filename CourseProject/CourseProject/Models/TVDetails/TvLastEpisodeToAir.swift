import Foundation

struct TvLastEpisodeToAir : Codable {
	let airDate : String?
	let episodeNumber : Int?
	let id : Int?
	let name : String?
	let overview : String?
	let productionCode : String?
	let seasonNumber : Int?
	let stillPath : String?
	let voteAverage : Double?
	let voteCount : Int?

	enum CodingKeys: String, CodingKey {
		case airDate = "air_date"
		case episodeNumber = "episode_number"
		case id = "id"
		case name = "name"
		case overview = "overview"
		case productionCode = "production_code"
		case seasonNumber = "season_number"
		case stillPath = "still_path"
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        airDate = try values.decodeIfPresent(String.self, forKey: .airDate)
        episodeNumber = try values.decodeIfPresent(Int.self, forKey: .episodeNumber)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
        productionCode = try values.decodeIfPresent(String.self, forKey: .productionCode)
        seasonNumber = try values.decodeIfPresent(Int.self, forKey: .seasonNumber)
        stillPath = try values.decodeIfPresent(String.self, forKey: .stillPath)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
	}
}
