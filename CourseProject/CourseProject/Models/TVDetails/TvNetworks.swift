import Foundation

struct TvNetworks : Codable {
	let name : String?
	let id : Int?
	let logoPath : String?
	let originCountry : String?

	enum CodingKeys: String, CodingKey {
		case name = "name"
		case id = "id"
		case logoPath = "logo_path"
		case originCountry = "origin_country"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        logoPath = try values.decodeIfPresent(String.self, forKey: .logoPath)
        originCountry = try values.decodeIfPresent(String.self, forKey: .originCountry)
	}
}
