import UIKit

class MainPageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.addSubview(titleBackgroundView)
        posterImageView.layer.cornerRadius = 15
    }
    
    func configure(with result: Result) {
        if let titleText = result.originalTitle ?? result.originalName ?? result.title {
            titleLabel.text = titleText
        }
        if let posterPath = result.posterPath {
            NetworkManager.shared.setImageFor(imageView: posterImageView, path: posterPath)
        }
    }
}
