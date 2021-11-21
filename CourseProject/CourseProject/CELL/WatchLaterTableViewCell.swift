import UIKit
import RealmSwift

class WatchLaterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    let realm = try! Realm()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.posterImageView.layer.cornerRadius = 10
    }
    
    
    func configure(with data: WatchLater) {
        NetworkManager.shared.setImageFor(imageView: posterImageView, path: data.posterPath)
        self.titleLabel.text = data.title
        self.releaseDateLabel.text = data.releaseDate
    }
    
}
