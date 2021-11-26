import Foundation

struct JSONActors : Codable {
	let results : [Actors]?

    enum CodingKeys: String, CodingKey {
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		results = try values.decodeIfPresent([Actors].self, forKey: .results)
	}
}
