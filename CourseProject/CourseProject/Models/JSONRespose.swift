import Foundation
struct JSONResponse : Codable {
    let results : [Result]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Result].self, forKey: .results)
    }
}

