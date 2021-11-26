import Foundation

struct Actors : Codable {
	let id : Int?
	let profilePath : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case profilePath = "profile_path"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
	}
}
