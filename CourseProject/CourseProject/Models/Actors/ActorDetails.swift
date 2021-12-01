import Foundation

struct ActorDetails: Codable {
	let biography : String?
	let birthday : String?
	let id : Int?
	let name : String?
	let placeOfBirth : String?
	let popularity : Double?
	let profilePath : String?

	enum CodingKeys: String, CodingKey {
		case biography = "biography"
		case birthday = "birthday"
		case id = "id"
		case name = "name"
		case placeOfBirth = "place_of_birth"
		case popularity = "popularity"
		case profilePath = "profile_path"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		biography = try values.decodeIfPresent(String.self, forKey: .biography)
		birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        placeOfBirth = try values.decodeIfPresent(String.self, forKey: .placeOfBirth)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
	}
}
