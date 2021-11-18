import UIKit
import SDWebImage

class MainPageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with result: Result) {
        if let titleText = result.originalTitle ?? result.originalName ?? result.title {
            titleLabel.text = titleText
        }
        if let posterPath = result.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500/" + posterPath
            let url = URL(string: urlString)
            posterImageView.sd_setImage(with: url, completed: nil)
            posterImageView.layer.cornerRadius = 15
        }
    }
}
