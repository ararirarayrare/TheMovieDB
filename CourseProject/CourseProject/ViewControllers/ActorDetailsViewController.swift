import UIKit

class ActorDetailsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var biographyLabel: UILabel!
    
    var knownForList: [Known_for] = []
    var actorDetails: ActorDetails?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellName = "KnowForCollectionViewCell"
        collectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        setupActorDetailsPage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = 10
    }
    
}

extension ActorDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return knownForList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KnowForCollectionViewCell", for: indexPath) as? KnowForCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: knownForList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 2/3
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mediaType = knownForList[indexPath.item].media_type else { return }
        guard let searchId = knownForList[indexPath.item].id else { return }
        if mediaType == "movie" {
            pushMovieDetailsViewController(searchId: searchId)
        }
        if mediaType == "tv" {
            pushTvDetailsViewController(searchId: searchId)
        }
    }
    
}

// MARK: - My functions.

extension ActorDetailsViewController {
    private func setupActorDetailsPage() {
        if let profilePath = actorDetails?.profile_path {
            NetworkManager.shared.setImageFor(imageView: profileImageView, path: profilePath)
        }
        if let actorName = actorDetails?.name {
            actorNameLabel.text = actorName
        } else {
            actorNameLabel.isHidden = true
        }
        if let birthDate = actorDetails?.birthday {
            birthDateLabel.text = "Birth date: \(birthDate)"
        } else {
            birthDateLabel.isHidden = true
        }
        if let birthPlace = actorDetails?.place_of_birth {
            birthPlaceLabel.text = "Born in: \(birthPlace)"
        } else {
            birthPlaceLabel.isHidden = true
        }
        if let popularity = actorDetails?.popularity {
            popularityLabel.text = "Actor ratings: \(popularity)"
        }
        if let biography = actorDetails?.biography {
            biographyLabel.text = biography
        } else {
            biographyLabel.isHidden = true
        }
    }
    private func pushMovieDetailsViewController(searchId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else { return }
        NetworkManager.shared.requestDetailsForSelectedMovie(searchId) { movie in
            movieDetailsViewController.movie = movie
            NetworkManager.shared.requestVideoDetails(searchId) { videoList in
                movieDetailsViewController.videosList = videoList
                self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
            }
        }
        
    }
    private func pushTvDetailsViewController(searchId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tvDetailsViewController = storyboard.instantiateViewController(withIdentifier: "TvDetailsViewController") as? TvDetailsViewController else { return }
        NetworkManager.shared.requestDetailsForSelectedTV(searchId) { tv in
            tvDetailsViewController.tv = tv
            self.navigationController?.pushViewController(tvDetailsViewController, animated: true)
        }
    }
}