import UIKit
import youtube_ios_player_helper
import SafariServices

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
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
//    var video: VideoResults?
    private var watchLaterData = WatchLater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMovieDetailsPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualEffect.alpha = 0.75
        watchLaterButton.layer.cornerRadius = 10
        posterPathImageView.clipsToBounds = true
        posterPathImageView.layer.cornerRadius = 12
    }
    @IBAction func watchLaterButtonPressed(_ sender: UIButton) {
        var alertText = ""
        let saved = DataManager.shared.save(object: watchLaterData)
        if saved {
            alertText = "Saved to watch list!"
        } else {
            alertText = "This film is already saved!"
        }
        let alert = AlertService.shared.alert(text: alertText)
        let deadline = DispatchTime.now() + 1
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            alert.dismiss(animated: true, completion: nil)
            if alertText == "Saved to watch list!" {
                self.navigationController?.popViewController(animated: true)
            }
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
        let font = UIFont(name: "Courier New", size: 16)
        if let id = movie?.id {
            NetworkManager.shared.requestVideoDetails(id) { video in
                if let key = video.key {
                    self.trailerPlayerView.load(withVideoId: key)
                }
            }
        }
        if let id = movie?.id {
            watchLaterData.id = id
            watchLaterData.numberOfSeasons = 0
        }
        if let backdropPath = movie?.backdropPath {
            NetworkManager.shared.setImageFor(imageView: backdropPathImageView, path: backdropPath)
        }
        if let posterPath = movie?.posterPath {
            NetworkManager.shared.setImageFor(imageView: posterPathImageView, path: posterPath)
            watchLaterData.posterPath = posterPath
        }
        if let titleText = movie?.originalTitle ?? movie?.title {
            titleLabel.text = titleText
            watchLaterData.title = titleText
        }
        if let voteAverage = movie?.voteAverage {
            if let voteCount = movie?.voteCount {
                ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)"
            }
        } else {
            ratingsLabel.font = font
            ratingsLabel.text = "No information about ratings.."
        }
        if let statusText = movie?.status {
            statusLabel.text = "Status: \(statusText)"
        } else {
            statusLabel.font = font
            statusLabel.text = "No information about about status.."
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
            if overviewText == "" {
                overviewLabel.font = font
                overviewLabel.text = "No imformation about overview :("
            } else {
                overviewLabel.text = overviewText
            }
        }
        if let releaseDateText = movie?.releaseDate {
            if releaseDateText == "" {
                releaseDateLabel.font = font
                releaseDateLabel.text = "No information about release date.."
            } else {
                releaseDateLabel.text = releaseDateText
                watchLaterData.releaseDate = releaseDateText
            }
        }
        if let runtimeText = movie?.runtime {
            if runtimeText == 0 {
                runtimeLabel.font = font
                runtimeLabel.text = "No information about movie duration.."
            } else {
                runtimeLabel.text = "Run time: \(runtimeText) minutes"
            }
        }
        if let budgetText = movie?.budget {
            if budgetText == 0 {
                budgetLabel.font = font
                budgetLabel.text = "No information about budget.."
            } else {
                budgetLabel.text = "\(budgetText) USD"
            }
        }
        if let revenueText = movie?.revenue {
            if revenueText == 0 {
                revenueLabel.font = font
                revenueLabel.text = "No information about revenue.."
            } else {
                revenueLabel.text = "\(revenueText) USD"
            }
        }
        if let websiteText = movie?.homepage {
            if websiteText == "" {
                websiteLabel.font = font
                websiteLabel.text = "No information about movie homepage.."
            } else {
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
                tapGesture.numberOfTapsRequired = 1
                websiteLabel.addGestureRecognizer(tapGesture)
                websiteLabel.text = websiteText
            }
        }
        if let taglineText = movie?.tagline {
            taglineLabel.text = taglineText
        }
    }
}
