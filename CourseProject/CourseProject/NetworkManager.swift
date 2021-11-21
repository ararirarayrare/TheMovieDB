import Foundation
import Alamofire
import SDWebImage

struct NetworkManager {
    static let shared = NetworkManager()
    init(){}
    
    func requestMovies(_ query: String, segmentTitle: String, completion: @escaping(([Result]) -> ())) {
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
    func requestTrending(segmentTitle: String, completion: @escaping(([Result]) -> ())) {
        let url = "https://api.themoviedb.org/3/trending/\(segmentTitle)/day?api_key=5d24ad36a0d98c3987c8768e13053416"
        AF.request(url).responseJSON { responce in
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(JSONResponse.self, from: responce.data!) {
                let movies = data.results ?? []
                completion(movies)
            }
        }
    }
    func requestDetailsForSelectedMovie(_ id: Int, completion: @escaping((JSONMovieDetails) -> ())) {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=5d24ad36a0d98c3987c8768e13053416"
        AF.request(url).responseJSON { responce in
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(JSONMovieDetails.self, from: responce.data!) {
                completion(data)
            }
        }
    }
    func requestDetailsForSelectedTV(_ id: Int, completion: @escaping((JSONTvDetails) -> ())) {
        let url = "https://api.themoviedb.org/3/tv/\(id)?api_key=5d24ad36a0d98c3987c8768e13053416"
        AF.request(url).responseJSON { responce in
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(JSONTvDetails.self, from: responce.data!) {
                completion(data)
            }
        }
    }
    func requestVideoDetails(_ id: Int, completion: @escaping(([VideoResults]) -> ())) {
        let url = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=5d24ad36a0d98c3987c8768e13053416"
        AF.request(url).responseJSON { responce in
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(JSONVideo.self, from: responce.data!) {
                if let videos = data.results {
                    completion(videos)
                }
            }
        }
    }
}

// MARK: - SDWebImage function.

extension NetworkManager {
    func setImageFor(imageView: UIImageView, path: String) {
        let stringURL = "https://image.tmdb.org/t/p/w500" + path
        let url = URL(string: stringURL)
        imageView.sd_setImage(with: url, completed: nil)
    }
}
