import Foundation
import Alamofire

struct NetworkManager {
    var genresId: [Int: String] = [10759: "Action & Adventure", 16: "Animation", 35: "Comedy", 80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family", 10762: "Kids", 9648: "Mystery", 10763: "News", 10764: "Reality", 10765: "Sci-Fi & Fantasy", 10766: "Soap", 10767: "Talk", 10768: "War & Politics", 37: "Western", 28: "Action", 12: "Adventure", 36: "History", 27: "Horror", 10402: "Music", 10749: "Romance", 878: "Science Fiction", 10770: "TV Movie", 53: "Thriller", 10752: "War"]
    
    static let shared = NetworkManager()
    init(){}
    
    func requestMovies(_ query: String, segmentTitle: String, completion: @escaping(([Movie]) -> ())) {
        let url = "https://api.themoviedb.org/3/search/\(segmentTitle)?api_key=5d24ad36a0d98c3987c8768e13053416&query="
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        
        AF.request(url + newQuery).responseJSON { responce in
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(JSONResponse.self, from: responce.data!) {
                let movies = data.results ?? []
                completion(movies)
            }
        }
    }
    func requestTrending(segmentTitle: String, completion: @escaping(([Movie]) -> ())) {
        let url = "https://api.themoviedb.org/3/trending/\(segmentTitle)/day?api_key=5d24ad36a0d98c3987c8768e13053416"
        AF.request(url).responseJSON { responce in
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(JSONResponse.self, from: responce.data!) {
                let movies = data.results ?? []
                completion(movies)
            }
        }
    }
}
