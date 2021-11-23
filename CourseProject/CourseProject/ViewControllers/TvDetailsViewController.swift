import UIKit
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
    private var watchLaterData = WatchLater()
    private let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellName = "TvSeasoneCollectionViewCell"
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
        setupTvDetailsPage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        watchLaterButton.layer.cornerRadius = 10
        posterPathImageView.clipsToBounds = true
        posterPathImageView.layer.cornerRadius = 12
        autorImageView.clipsToBounds = true
        autorImageView.layer.cornerRadius = 10
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
    private func setupTvDetailsPage() {
        if let id = tv?.id {
            watchLaterData.id = id
        }
        if let backdropPath = tv?.backdropPath {
            NetworkManager.shared.setImageFor(imageView: backdropPathImageView, path: backdropPath)
        }
        if let posterPath = tv?.posterPath {
            NetworkManager.shared.setImageFor(imageView: posterPathImageView, path: posterPath)
            watchLaterData.posterPath = posterPath
        }
        if let titleText = tv?.originalName ?? tv?.name {
            titleLabel.text = titleText
            watchLaterData.title = titleText
        }
        if let voteAverage = tv?.voteAverage {
            if let voteCount = tv?.voteCount {
                ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)."
            }
        }
        if let statusText = tv?.status {
            statusLabel.text = "Status: \(statusText).˚"
        }
        if let arrayOfGenres = tv?.genres {
            var genresText = ""
            for item in arrayOfGenres {
                if let genre = item.name {
                    genresText += "\(genre) "
                }
            }
            genresLabel.text = genresText
        }
        if let overviewText = tv?.overview {
            if overviewText == "" {
                overviewLabel.text = "The server didn't send us the overview :("
            } else {
                overviewLabel.text = overviewText
            }
        }
        if let firstReleaseText = tv?.firstAirDate {
            if firstReleaseText == "" {
                firstReleaseDateLabel.text = "the server didn't send us the release date"
            } else {
                firstReleaseDateLabel.text = firstReleaseText
                watchLaterData.releaseDate = firstReleaseText
            }
        }
        if let lastReleaseText = tv?.lastAirDate {
            if lastReleaseText == "" {
                lastReleaseDateLabel.text = "the server didn't send us the release date"
            } else {
                lastReleaseDateLabel.text = lastReleaseText
            }
        }
        var seasonesEpisodesRuntimeText = ""
        if let seasonesCount = tv?.numberOfSeasons {
            watchLaterData.numberOfSeasons = seasonesCount
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
            if episodeRuntime == 0 {
                seasonsEpisodesRuntimeLabel.text = seasonesEpisodesRuntimeText
            } else {
                seasonesEpisodesRuntimeText += "\nEpisode runtime: \(episodeRuntime) minutes"
                seasonsEpisodesRuntimeLabel.text = seasonesEpisodesRuntimeText
            }
        }
        if let websiteLinkText = tv?.homepage {
            if websiteLinkText == "" {
                websiteLinkLabel.text =  "Sorry, but try to find it yourself :("
            } else {
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
                tapGesture.numberOfTapsRequired = 1
                websiteLinkLabel.addGestureRecognizer(tapGesture)
                websiteLinkLabel.text = websiteLinkText
            }
        }
        if let autorNameText = tv?.createdBy?.first?.name {
            autorNameLabel.text = autorNameText
        }
        if let profilePath = tv?.createdBy?.first?.profilePath {
            NetworkManager.shared.setImageFor(imageView: autorImageView, path: profilePath)
        }
        if let taglineText = tv?.tagline {
            taglineLabel.text = taglineText
        }
    }
}

// MARK: - CollectionView configuration.

extension TvDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let seasons = tv?.seasons {
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
        if let seasons = tv?.seasons {
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
        let height = collectionView.frame.height
        let width = height * 2/3
        return CGSize(width: width, height: height)
    }
}
