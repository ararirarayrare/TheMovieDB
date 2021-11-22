import Foundation

struct VideoResults : Codable {
    let key : String?
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
    }
}
