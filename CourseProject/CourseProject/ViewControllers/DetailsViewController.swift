import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    var movie: Movie?
    var genres: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWith()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = 10
    }
    
    
// MARK: - My functions. DetailsViewController configuration.
    
    private func configureWith() {
        if let backdropPath = movie?.backdrop_path {
            let imageURLString = "https://image.tmdb.org/t/p/w500/" + backdropPath
            let imageURL = URL(string: imageURLString)
            backdropImageView.sd_setImage(with: imageURL, completed: nil)
            }
        if let posterPath = movie?.poster_path {
            let imageURLString = "https://image.tmdb.org/t/p/w500/" + posterPath
            let imageURL = URL(string: imageURLString)
            posterImageView.sd_setImage(with: imageURL, completed: nil)
        }
        if let title = movie?.original_title ?? movie?.original_name ?? movie?.title {
            self.titleLabel.text = title
        }
        if let originalLanguage = movie?.original_language {
            self.originalLanguageLabel.text = "Original language: " + originalLanguage.uppercased()
        }
        if movie?.adult == true {
            self.adultLabel.text = "For adults! 18+"
            self.adultLabel.textColor = .red
        } else {
            self.adultLabel.text = "No age limit."
            self.adultLabel.alpha = 0.7
        }
        if genres != nil {
            var genresText = ""
            for item in genres! {
                genresText += "\(item)  "
            }
            self.genresLabel.text = genresText
        }
        if let overviewText = movie?.overview {
            self.overviewLabel.text = overviewText
        }
        if let releaseDateText = movie?.release_date {
            self.releaseDateLabel.text = releaseDateText
        }
        if let voteAverage = movie?.vote_average {
            if let voteCount = movie?.vote_count {
                ratingsLabel.text = "\(voteAverage) / 10    (\(voteCount) votes)"
            }
        }
    }
}
 

