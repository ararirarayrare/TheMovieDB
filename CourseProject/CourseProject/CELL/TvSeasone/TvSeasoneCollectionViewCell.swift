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
            let stringURL = "https://image.tmdb.org/t/p/w500" + posterPath
            let url = URL(string: stringURL)
            self.posterPathImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
