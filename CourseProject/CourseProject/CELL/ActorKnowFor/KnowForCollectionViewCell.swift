import UIKit

class KnowForCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 12
    }
    
    func configure(with knownFor: Known_for) {
        if let posterPath = knownFor.poster_path {
            NetworkManager.shared.setImageFor(imageView: posterImageView, path: posterPath)
        }
    }
}
