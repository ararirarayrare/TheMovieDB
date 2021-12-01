import UIKit

class KnowForCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 12
    }
    
    func configure(with knownFor: KnownFor) {
        if let posterPath = knownFor.posterPath {
            NetworkManager.shared.setImageFor(imageView: posterImageView, path: posterPath)
        }
    }
}
