import UIKit
import SDWebImage

class TvSeasoneCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterPathImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    func configureWith(seasone: TvSeasons) {
        if let posterPath = seasone.posterPath {
            NetworkManager.shared.setImageFor(imageView: posterPathImageView, path: posterPath)
        }
    }
}
