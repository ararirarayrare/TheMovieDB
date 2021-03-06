import UIKit
import SafariServices

class TvDetailsViewController: UIViewController {
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let seasonesCellName = String(describing: TvSeasoneCollectionViewCell.self)
        collectionView.register(UINib(nibName: seasonesCellName, bundle: nil), forCellWithReuseIdentifier: seasonesCellName)
        setupTvDetailsPage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualEffect.alpha = 0.75
        watchLaterButton.layer.cornerRadius = 10
        posterPathImageView.clipsToBounds = true
        posterPathImageView.layer.cornerRadius = 12
        autorImageView.clipsToBounds = true
        autorImageView.layer.cornerRadius = 10
    }
    
    @IBAction func watchLaterButtonPressed(_ sender: UIButton) {
        var alertText = ""
        let saved = DataManager.shared.save(object: watchLaterData)
        if saved {
            alertText = "Saved to watch list!"
        } else {
            alertText = "This tv-show is already saved!"
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
        let font = UIFont(name: "Courier New", size: 16)
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
                ratingsLabel.text = "Ratings: \(voteAverage) / 10  (\(voteCount) votes)"
            }
        } else {
            ratingsLabel.font = font
            ratingsLabel.text = "No information about ratings.."
        }
        if let statusText = tv?.status {
            statusLabel.text = "Status: \(statusText)??"
        } else {
            statusLabel.font = font
            statusLabel.text = "No information about about status.."
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
                overviewLabel.font = font
                overviewLabel.text = "No information about about overview.."
            } else {
                overviewLabel.text = overviewText
            }
        }
        if let firstReleaseText = tv?.firstAirDate {
            if firstReleaseText == "" {
                firstReleaseDateLabel.font = font
                firstReleaseDateLabel.text = "No information about about first release date.."
            } else {
                firstReleaseDateLabel.text = firstReleaseText
                watchLaterData.releaseDate = firstReleaseText
            }
        }
        if let lastReleaseText = tv?.lastAirDate {
            if lastReleaseText == "" {
                lastReleaseDateLabel.font = font
                lastReleaseDateLabel.text = "No information about about last release date.."
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
                websiteLinkLabel.font = font
                websiteLinkLabel.text =  "No information about about tv-show homepage.."
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
        guard let seasons = tv?.seasons else { return 0 }
        var rows: [TvSeasons] = []
        for item in seasons {
            if item.posterPath != nil {
                rows.append(item)
            }
        }
        return rows.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: TvSeasoneCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TvSeasoneCollectionViewCell else { return UICollectionViewCell() }
        if let seasons = tv?.seasons {
            var posters: [TvSeasons] = []
            for item in seasons {
                if item.posterPath != nil {
                    posters.append(item)
                }
            }
            cell.configureWith(seasone: posters[indexPath.item])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 2/3
        return CGSize(width: width, height: height)
    }
}
