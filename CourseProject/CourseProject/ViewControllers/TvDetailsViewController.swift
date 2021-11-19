import UIKit
import SDWebImage
import SafariServices

class TvDetailsViewController: UIViewController {
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var posterPathImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var firstReleaseDateLabel: UILabel!
    @IBOutlet weak var lastReleaseDateLabel: UILabel!
    @IBOutlet weak var seasonsEpisodesRuntimeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var websiteLinkLabel: UILabel!
    @IBOutlet weak var autorNameLabel: UILabel!
    @IBOutlet weak var autorImageView: UIImageView!
    @IBOutlet weak var watchLaterButton: UIButton!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var tv: JSONTvDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellName = "TvSeasoneCollectionViewCell"
        let cellNib = UINib(nibName: cellName, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
        self.setupTvDetailsPage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.watchLaterButton.layer.cornerRadius = 10
        self.posterPathImageView.clipsToBounds = true
        self.posterPathImageView.layer.cornerRadius = 12
        self.autorImageView.clipsToBounds = true
        self.autorImageView.layer.cornerRadius = 10
    }
    
    @objc func clickLabel() {
        if let stringURL = tv?.homepage {
            if let url = URL(string: stringURL) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - My functions.

extension TvDetailsViewController {
    func setupTvDetailsPage() {
        if let backdropPath = tv?.backdropPath {
            let stringURL = "https://image.tmdb.org/t/p/w500" + backdropPath
            let url = URL(string: stringURL)
            self.backdropPathImageView.sd_setImage(with: url, completed: nil)
        }
        if let posterPath = tv?.posterPath {
            let stringURL = "https://image.tmdb.org/t/p/w500" + posterPath
            let url = URL(string: stringURL)
            self.posterPathImageView.sd_setImage(with: url, completed: nil)
        }
        if let titleText = tv?.originalName ?? tv?.name {
            self.titleLabel.text = titleText
        }
        if let voteAverage = tv?.voteAverage {
            if let voteCount = tv?.voteCount {
                self.ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)."
            }
        }
        if let statusText = tv?.status {
            self.statusLabel.text = "Status: \(statusText).˚"
        }
        if let arrayOfGenres = tv?.genres {
            var genresText = ""
            for item in arrayOfGenres {
                if let genre = item.name {
                    genresText += "\(genre) "
                }
            }
            self.genresLabel.text = genresText
        }
        if let overviewText = tv?.overview {
            self.overviewLabel.text = overviewText
        }
        if let firstReleaseText = tv?.firstAirDate {
            self.firstReleaseDateLabel.text = firstReleaseText
        }
        if let lastReleaseText = tv?.lastAirDate {
            self.lastReleaseDateLabel.text = lastReleaseText
        }
        var seasonesEpisodesRuntimeText = ""
        if let seasonesCount = tv?.numberOfSeasons {
            if seasonesCount == 1 {
                seasonesEpisodesRuntimeText += "\(seasonesCount) seasone"
            } else {
                seasonesEpisodesRuntimeText += "\(seasonesCount) seasones"
            }
        }
        if let episodesCount = tv?.numberOfEpisodes {
            if episodesCount == 1 {
                seasonesEpisodesRuntimeText += "\n\(episodesCount) episode"
            } else {
                seasonesEpisodesRuntimeText += "\n\(episodesCount) episodes"
            }
        }
        if let episodeRuntime = tv?.episodeRuntime?.first {
            seasonesEpisodesRuntimeText += "\nEpisode runtime: \(episodeRuntime) minutes"
        }
        self.seasonsEpisodesRuntimeLabel.text = seasonesEpisodesRuntimeText
        if let websiteLinkText = tv?.homepage {
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
            tapGesture.numberOfTapsRequired = 1
            self.websiteLinkLabel.addGestureRecognizer(tapGesture)
            self.websiteLinkLabel.text = websiteLinkText
        }
        if let autorNameText = tv?.createdBy?.first?.name {
            self.autorNameLabel.text = autorNameText
        }
        if let profilePath = tv?.createdBy?.first?.profilePath {
            let stringURL = "https://image.tmdb.org/t/p/w500" + profilePath
            let url = URL(string: stringURL)
            self.autorImageView.sd_setImage(with: url, completed: nil)
        }
        if let taglineText = tv?.tagline {
            self.taglineLabel.text = taglineText
        }
    }
}

// MARK: - CollectionView configuration.

extension TvDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let seasons = self.tv?.seasons {
            var rows: [TvSeasons] = []
            for item in seasons {
                if item.posterPath != nil {
                    rows.append(item)
                }
            }
            return rows.count
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TvSeasoneCollectionViewCell", for: indexPath) as? TvSeasoneCollectionViewCell
        if let seasons = self.tv?.seasons {
            var posters: [TvSeasons] = []
            for item in seasons {
                if item.posterPath != nil {
                    posters.append(item)
                }
            }
            cell?.configureWith(seasone: posters[indexPath.item])
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.collectionView.frame.height
        let width = height * 2/3
        return CGSize(width: width, height: height)
    }
}
