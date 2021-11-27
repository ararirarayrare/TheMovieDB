import Foundation

struct Known_for : Codable {
	let name : String?
	let original_name : String?
	let poster_path : String?
    let media_type : String?
    let id : Int?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case original_name = "original_name"
		case poster_path = "poster_path"
        case media_type = "media_type"
        case id = "id"
        
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		original_name = try values.decodeIfPresent(String.self, forKey: .original_name)
		poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}
