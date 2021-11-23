import UIKit
import youtube_ios_player_helper
import SafariServices

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var posterPathImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet var trailerPlayerView: YTPlayerView!
    @IBOutlet weak var watchLaterButton: UIButton!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var movie: JSONMovieDetails?
    var videosList: [VideoResults]?
    private var watchLaterData = WatchLater()
    private let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMovieDetailsPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        watchLaterButton.layer.cornerRadius = 10
        posterPathImageView.clipsToBounds = true
        posterPathImageView.layer.cornerRadius = 12
    }
    @IBAction func watchLaterButtonPressed(_ sender: UIButton) {
        let alert = alertService.alert(text: "Saved to watch list!")
        let when = DispatchTime.now() + 1
        DataManager.shared.save(object: watchLaterData)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func clickLabel() {
        guard let stringURL = movie?.homepage else { return }
        guard let url = URL(string: stringURL) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: - My functions.

extension MovieDetailsViewController {
    private func setupMovieDetailsPage() {
        guard let id = movie?.id else { return }
        watchLaterData.id = id
        watchLaterData.numberOfSeasons = 0
        
        guard let backdropPath = movie?.backdropPath else { return }
        NetworkManager.shared.setImageFor(imageView: backdropPathImageView, path: backdropPath)
        
        guard let posterPath = movie?.posterPath else { return }
        NetworkManager.shared.setImageFor(imageView: posterPathImageView, path: posterPath)
        watchLaterData.posterPath = posterPath
        
        guard let titleText = movie?.originalTitle ?? movie?.title else { return }
        titleLabel.text = titleText
        watchLaterData.title = titleText
        
        guard let voteAverage = movie?.voteAverage else { return }
        guard let voteCount = movie?.voteCount else { return }
        ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)."
        
        guard let statusText = movie?.status else { return }
        statusLabel.text = "Status: \(statusText)."
        
        guard let arrayOfGenres = movie?.genres else { return }
        var genresText = ""
        for item in arrayOfGenres {
            guard let genre = item.name else { return }
            genresText += "\(genre) "
        }
        genresLabel.text = genresText
        
        guard let overviewText = movie?.overview else { return }
        if overviewText == "" {
            overviewLabel.text = "The server didn't send us the overview :(\n\nBut we think this film is good!"
        } else {
        overviewLabel.text = overviewText
        }
        guard let releaseDateText = movie?.releaseDate else { return }
        if releaseDateText == "" {
            releaseDateLabel.text = "the server didn't send us the release date"
        } else {
        releaseDateLabel.text = releaseDateText
        watchLaterData.releaseDate = releaseDateText
        }
        guard let runtimeText = movie?.runtime else { return }
        if runtimeText == 0 {
            runtimeLabel.text = "The server didn't send us the film duration :(\nBut is it too neccesary?"
        } else {
        runtimeLabel.text = "Run time: \(runtimeText) minutes."
        }
        guard let budgetText = movie?.budget else { return }
        if budgetText == 0 {
            budgetLabel.text = "too much.."
        } else {
        budgetLabel.text = "\(budgetText) USD"
        }
        guard let revenueText = movie?.revenue else { return }
        if revenueText == 0 {
            revenueLabel.text = "who knows.."
        } else {
        revenueLabel.text = "\(revenueText) USD"
        }
        guard let websiteText = movie?.homepage else { return }
        if websiteText == "" {
            websiteLabel.text = "Sorry, but try to find it yourself :("
        } else {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
        tapGesture.numberOfTapsRequired = 1
        websiteLabel.addGestureRecognizer(tapGesture)
        websiteLabel.text = websiteText
        }
        guard let videoId = videosList?.first?.key else { return }
        trailerPlayerView.load(withVideoId: videoId)
        
        guard let taglineText = movie?.tagline else { return }
        taglineLabel.text = taglineText
    }





//private func setupMovieDetailsPage() {
//    if let id = movie?.id {
//        self.watchLaterData.id = id
//        self.watchLaterData.numberOfSeasons = 0
//    }
//    if let backdropPath = movie?.backdropPath {
//        NetworkManager.shared.setImageFor(imageView: backdropPathImageView, path: backdropPath)
//    }
//    if let posterPath = movie?.posterPath {
//        NetworkManager.shared.setImageFor(imageView: posterPathImageView, path: posterPath)
//        self.watchLaterData.posterPath = posterPath
//    }
//    if let titleText = movie?.originalTitle ?? movie?.title {
//        self.titleLabel.text = titleText
//        self.watchLaterData.title = titleText
//    }
//    if let voteAverage = movie?.voteAverage {
//        if let voteCount = movie?.voteCount {
//            self.ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)."
//        }
//    }
//    if let statusText = movie?.status {
//        self.statusLabel.text = "Status: \(statusText)."
//    }
//    if let arrayOfGenres = movie?.genres {
//        var genresText = ""
//        for item in arrayOfGenres {
//            if let genre = item.name {
//                genresText += "\(genre) "
//            }
//        }
//        genresLabel.text = genresText
//    }
//    if let overviewText = movie?.overview {
//        self.overviewLabel.text = overviewText
//    }
//    if let releaseDateText = movie?.releaseDate {
//        self.releaseDateLabel.text = releaseDateText
//        self.watchLaterData.releaseDate = releaseDateText
//    }
//    if let runtimeText = movie?.runtime {
//        self.runtimeLabel.text = "Run time: \(runtimeText) minutes."
//    }
//    if let budgetText = movie?.budget {
//        self.budgetLabel.text = "\(budgetText) USD"
//    }
//    if let revenueText = movie?.revenue {
//        self.revenueLabel.text = "\(revenueText) USD"
//    }
//    if let websiteText = movie?.homepage {
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
//        tapGesture.numberOfTapsRequired = 1
//        self.websiteLabel.addGestureRecognizer(tapGesture)
//        self.websiteLabel.text = websiteText
//    }
//    if let videoId = videosList?.first?.key {
//        print(videoId)
//        self.trailerPlayerView.load(withVideoId: videoId)
//    }
//    if let taglineText = movie?.tagline {
//        self.taglineLabel.text = taglineText
//    }
//}
}
