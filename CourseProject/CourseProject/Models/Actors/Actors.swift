import Foundation

struct Actors : Codable {
	let id : Int?
    let knownFor : [KnownFor]?
	let profilePath : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
        case knownFor = "known_for"
		case profilePath = "profile_path"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        knownFor = try values.decodeIfPresent([KnownFor].self, forKey: .knownFor)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
	}
}
