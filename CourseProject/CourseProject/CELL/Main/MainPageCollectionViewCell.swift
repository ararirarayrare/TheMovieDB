import UIKit

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
            NetworkManager.shared.setImageFor(imageView: posterImageView, path: posterPath)
            posterImageView.layer.cornerRadius = 15
        }
    }
}
