import Foundation

struct JSONTvDetails : Codable {
	let backdropPath : String?
	let createdBy : [TvCreatedBy]?
	let episodeRuntime : [Int]?
	let firstAirDate : String?
	let genres : [TvGenres]?
	let homepage : String?
	let id : Int?
	let lastAirDate : String?
	let name : String?
	let numberOfEpisodes : Int?
	let numberOfSeasons : Int?
	let originalName : String?
	let overview : String?
	let posterPath : String?
	let seasons : [TvSeasons]?
	let status : String?
	let tagline : String?
	let type : String?
	let voteAverage : Double?
	let voteCount : Int?

	enum CodingKeys: String, CodingKey {
		case backdropPath = "backdrop_path"
		case createdBy = "created_by"
		case episodeRuntime = "episode_run_time"
		case firstAirDate = "first_air_date"
		case genres = "genres"
		case homepage = "homepage"
		case id = "id"
		case lastAirDate = "last_air_date"
		case name = "name"
		case numberOfEpisodes = "number_of_episodes"
		case numberOfSeasons = "number_of_seasons"
		case originalName = "original_name"
		case overview = "overview"
		case posterPath = "poster_path"
		case seasons = "seasons"
		case status = "status"
		case tagline = "tagline"
		case type = "type"
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        createdBy = try values.decodeIfPresent([TvCreatedBy].self, forKey: .createdBy)
        episodeRuntime = try values.decodeIfPresent([Int].self, forKey: .episodeRuntime)
        firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
		genres = try values.decodeIfPresent([TvGenres].self, forKey: .genres)
		homepage = try values.decodeIfPresent(String.self, forKey: .homepage)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        lastAirDate = try values.decodeIfPresent(String.self, forKey: .lastAirDate)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        numberOfEpisodes = try values.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        numberOfSeasons = try values.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
		seasons = try values.decodeIfPresent([TvSeasons].self, forKey: .seasons)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		tagline = try values.decodeIfPresent(String.self, forKey: .tagline)
		type = try values.decodeIfPresent(String.self, forKey: .type)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
	}
}
