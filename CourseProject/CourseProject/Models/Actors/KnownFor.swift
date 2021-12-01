import Foundation

struct KnownFor : Codable {
	let name : String?
	let originalName : String?
	let posterPath : String?
    let mediaType : String?
    let id : Int?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case originalName = "original_name"
		case posterPath = "poster_path"
        case mediaType = "media_type"
        case id = "id"
        
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}
