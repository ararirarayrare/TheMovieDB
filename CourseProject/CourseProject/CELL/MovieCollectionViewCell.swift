import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with movie: Movie) {
        if let titleText = movie.original_title ?? movie.original_name ?? movie.title {
            titleLabel.text = titleText
        }
        if let posterPath = movie.poster_path {
            let urlString = "https://image.tmdb.org/t/p/w500/" + posterPath
            let url = URL(string: urlString)
            posterImageView.sd_setImage(with: url, completed: nil)
            posterImageView.layer.cornerRadius = 15
        }
    }
}
