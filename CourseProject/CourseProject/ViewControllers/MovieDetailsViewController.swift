import UIKit
import SDWebImage
import youtube_ios_player_helper
import SafariServices

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
        if let backdropPath = movie?.backdropPath {
            let stringURL = "https://image.tmdb.org/t/p/w500\(backdropPath)"
            let url = URL(string: stringURL)
            self.backdropPathImageView.sd_setImage(with: url, completed: nil)
        }
        if let posterPath = movie?.posterPath {
            let stringURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
            let url = URL(string: stringURL)
            self.posterPathImageView.sd_setImage(with: url, completed: nil)
        }
        if let titleLabelText = movie?.originalTitle ?? movie?.title {
            self.titleLabel.text = titleLabelText
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
