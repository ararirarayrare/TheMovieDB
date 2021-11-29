import Foundation
import Alamofire
import SDWebImage

struct NetworkManager {
    static let shared = NetworkManager()
    init(){}
    private let queue = DispatchQueue.global()
    
    func requestMovies(_ query: String, segmentTitle: String, completion: @escaping(([Result]) -> ())) {
        let url = "https://api.themoviedb.org/3/search/\(segmentTitle)?api_key=5d24ad36a0d98c3987c8768e13053416&query="
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        queue.async {
            AF.request(url + newQuery).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONResponse.self, from: responceData) else { return }
                guard let movies = data.results else { return }
                completion(movies)
            }
            completion([])
        }
    }
    func requestActors(completion:  @escaping(([Actors]) -> ())) {
        let url = "https://api.themoviedb.org/3/person/popular?api_key=5d24ad36a0d98c3987c8768e13053416"
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONActors.self, from: responceData) else { return }
                guard let actors = data.results else { return }
                var clearActorsList = [Actors]()
                for item in actors {
                    if item.profilePath != nil && item.known_for != nil  {
                        clearActorsList.append(item)
                    }
                }
                completion(clearActorsList)
            }
        }
    }
    func requestActorDetails(_ id: Int, completion: @escaping((ActorDetails) -> ())) {
        let url = "https://api.themoviedb.org/3/person/\(id)?api_key=5d24ad36a0d98c3987c8768e13053416"
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(ActorDetails.self, from: responceData) else { return }
                    completion(data)
            }
        }
    }
    func requestTrending(segmentTitle: String, completion: @escaping(([Result]) -> ())) {
        let url = "https://api.themoviedb.org/3/trending/\(segmentTitle)/day?api_key=5d24ad36a0d98c3987c8768e13053416"
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONResponse.self, from: responceData) else { return }
                guard let movies = data.results else { return }
                completion(movies)
            }
            completion([])
        }
    }
    func requestDetailsForSelectedMovie(_ id: Int, completion: @escaping((JSONMovieDetails) -> ())) {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=5d24ad36a0d98c3987c8768e13053416"
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONMovieDetails.self, from: responceData) else { return }
                completion(data)
            }
        }
    }
    func requestDetailsForSelectedTV(_ id: Int, completion: @escaping((JSONTvDetails) -> ())) {
        let url = "https://api.themoviedb.org/3/tv/\(id)?api_key=5d24ad36a0d98c3987c8768e13053416"
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONTvDetails.self, from: responceData) else { return }
                completion(data)
            }
        }
    }
    func requestVideoDetails(_ id: Int, completion: @escaping((VideoResults) -> ())) {
        let url = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=5d24ad36a0d98c3987c8768e13053416"
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONVideo.self, from: responceData) else  { return }
                guard let video = data.results?.first else { return }
                completion(video)
            }
        }
    }
}

// MARK: - SDWebImage function.

extension NetworkManager {
    func setImageFor(imageView: UIImageView, path: String) {
        let stringURL = "https://image.tmdb.org/t/p/w500" + path
        guard let url = URL(string: stringURL) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
}
