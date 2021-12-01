import Foundation
import Alamofire
import SDWebImage

struct NetworkManager {
    static let shared = NetworkManager()
    init(){}
    private let queue = DispatchQueue.global()
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "?api_key=5d24ad36a0d98c3987c8768e13053416"
    
    func requestMovies(_ query: String, segmentTitle: String, completion: @escaping(([Result]) -> ())) {
        let url = baseURL + "search/\(segmentTitle)" + apiKey + "&query="
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
        let url = baseURL + "person/popular" + apiKey
        queue.async {
            AF.request(url).responseJSON { responce in
                let decoder = JSONDecoder()
                guard let responceData = responce.data else { return }
                guard let data = try? decoder.decode(JSONActors.self, from: responceData) else { return }
                guard let actors = data.results else { return }
                var clearActorsList = [Actors]()
                for item in actors {
                    if item.profilePath != nil && item.knownFor != nil  {
                        clearActorsList.append(item)
                    }
                }
                completion(clearActorsList)
            }
        }
    }
    func requestActorDetails(_ id: Int, completion: @escaping((ActorDetails) -> ())) {
        let url = baseURL + "person/\(id)" + apiKey
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
        let url = baseURL + "trending/\(segmentTitle)/day" + apiKey
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
        let url = baseURL + "movie/\(id)" + apiKey
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
        let url = baseURL + "tv/\(id)" + apiKey
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
        let url = baseURL + "movie/\(id)/videos" + apiKey
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
