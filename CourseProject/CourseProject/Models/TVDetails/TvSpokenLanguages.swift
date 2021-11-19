import Foundation

struct TvSpokenLanguages : Codable {
	let englishName : String?
	let iso_639_1 : String?
	let name : String?

	enum CodingKeys: String, CodingKey {
		case englishName = "english_name"
		case iso_639_1 = "iso_639_1"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        englishName = try values.decodeIfPresent(String.self, forKey: .englishName)
		iso_639_1 = try values.decodeIfPresent(String.self, forKey: .iso_639_1)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}
}
