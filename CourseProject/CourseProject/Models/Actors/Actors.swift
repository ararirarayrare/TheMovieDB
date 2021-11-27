import Foundation

struct Actors : Codable {
	let id : Int?
    let known_for : [Known_for]?
	let profilePath : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
        case known_for = "known_for"
		case profilePath = "profile_path"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        known_for = try values.decodeIfPresent([Known_for].self, forKey: .known_for)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
	}
}
