import UIKit
import youtube_ios_player_helper
import SafariServices
import RealmSwift

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var posterPathImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet var trailerPlayerView: YTPlayerView!
    @IBOutlet weak var watchLaterButton: UIButton!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var movie: JSONMovieDetails?
    var videosList: [VideoResults]?
    let realm = try! Realm()
    var watchLaterData = WatchLater()
    let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMovieDetailsPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.watchLaterButton.layer.cornerRadius = 10
        self.posterPathImageView.clipsToBounds = true
        self.posterPathImageView.layer.cornerRadius = 12
    }
    @IBAction func watchLaterButtonPressed(_ sender: UIButton) {
        let alert = alertService.alert()
        let when = DispatchTime.now() + 1
        try! realm.write({
            realm.add(watchLaterData)
        })
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func clickLabel() {
        if let stringURL = movie?.homepage {
            if let url = URL(string: stringURL) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - My functions.

extension MovieDetailsViewController {
    func setupMovieDetailsPage() {
        if let id = movie?.id {
            self.watchLaterData.id = id
            self.watchLaterData.numberOfSeasons = 0
        }
        if let backdropPath = movie?.backdropPath {
            NetworkManager.shared.setImageFor(imageView: backdropPathImageView, path: backdropPath)
        }
        if let posterPath = movie?.posterPath {
            NetworkManager.shared.setImageFor(imageView: posterPathImageView, path: posterPath)
            self.watchLaterData.posterPath = posterPath
        }
        if let titleText = movie?.originalTitle ?? movie?.title {
            self.titleLabel.text = titleText
            self.watchLaterData.title = titleText
        }
        if let voteAverage = movie?.voteAverage {
            if let voteCount = movie?.voteCount {
                self.ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)."
            }
        }
        if let runtimeText = movie?.runtime {
            self.runtimeLabel.text = "Run time: \(runtimeText) minutes."
        }
        if let arrayOfGenres = movie?.genres {
            var genresText = ""
            for item in arrayOfGenres {
                if let genre = item.name {
                    genresText += "\(genre) "
                }
            }
            genresLabel.text = genresText
        }
        if let overviewText = movie?.overview {
            self.overviewLabel.text = overviewText
        }
        if let releaseDateText = movie?.releaseDate {
            self.releaseDateLabel.text = releaseDateText
            self.watchLaterData.releaseDate = releaseDateText
        }
        if let budgetText = movie?.budget {
            self.budgetLabel.text = "\(budgetText) USD"
        }
        if let revenueText = movie?.revenue {
            self.revenueLabel.text = "\(revenueText) USD"
        }
        if let websiteText = movie?.homepage {
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
            tapGesture.numberOfTapsRequired = 1
            self.websiteLabel.addGestureRecognizer(tapGesture)
            self.websiteLabel.text = websiteText
        }
        if let videoId = videosList?.first?.key {
            print(videoId)
            self.trailerPlayerView.load(withVideoId: videoId)
        }
        if let taglineText = movie?.tagline {
            self.taglineLabel.text = taglineText
        }
    }
}

