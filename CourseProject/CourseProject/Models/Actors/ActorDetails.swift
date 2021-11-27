import Foundation

struct ActorDetails: Codable {
	let biography : String?
	let birthday : String?
	let id : Int?
	let name : String?
	let place_of_birth : String?
	let popularity : Double?
	let profile_path : String?

	enum CodingKeys: String, CodingKey {
		case biography = "biography"
		case birthday = "birthday"
		case id = "id"
		case name = "name"
		case place_of_birth = "place_of_birth"
		case popularity = "popularity"
		case profile_path = "profile_path"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		biography = try values.decodeIfPresent(String.self, forKey: .biography)
		birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		place_of_birth = try values.decodeIfPresent(String.self, forKey: .place_of_birth)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
		profile_path = try values.decodeIfPresent(String.self, forKey: .profile_path)
	}
}
