import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 30
    }

    func configure(with actor: Actors) {
        guard let profilePath = actor.profilePath else { return }
        NetworkManager.shared.setImageFor(imageView: profileImageView, path: profilePath )
    }
}
