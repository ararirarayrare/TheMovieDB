import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var mainNavigationItem: UINavigationItem!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private var moviesList: [Result] = []
    private var actorsList: [Actors] = []
    private var selectedSegmentTitle: String = "movie" {
        didSet {
            searchMovies()
            moviesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchActors()
        searchMovies()
        setupNavigationBar()
        activityIndicator.isHidden = true
        let actorsCellName = String(describing: ActorCollectionViewCell.self)
        let moviesCellName = String(describing: MainPageCollectionViewCell.self)
        actorsCollectionView.register(UINib(nibName: actorsCellName, bundle: nil), forCellWithReuseIdentifier: actorsCellName)
        moviesCollectionView.register(UINib(nibName: moviesCellName, bundle: nil), forCellWithReuseIdentifier: moviesCellName)
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        if segmentSelector.selectedSegmentIndex == 0 {
            selectedSegmentTitle = "movie"
        } else {
            selectedSegmentTitle = "tv"
        }
    }
}

// MARK: - SearchBar settings.

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let deadline = DispatchTime.now() + 1
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchMovies()
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.moviesCollectionView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMovies()
        moviesCollectionView.reloadData()
        view.endEditing(true)
    }
}

// MARK: - CollectionView configuration.

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == actorsCollectionView {
            return actorsList.count
        }
        return moviesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == actorsCollectionView {
            let identifier = String(describing: ActorCollectionViewCell.self)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell()}
            cell.configure(with: actorsList[indexPath.item])
            return cell
        }
        let identifier = String(describing: MainPageCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MainPageCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: moviesList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == actorsCollectionView {
            let aspectRatio: CGFloat = 2/3
            let topAndBottomSpacing: CGFloat = 12
            let height = actorsCollectionView.frame.height - topAndBottomSpacing
            let width = height * aspectRatio
            return CGSize(width: width, height: height)
        }
        let horizontalSpacing: CGFloat = 24
        let cellsPerLine: CGFloat = 3
        let aspectRatio: CGFloat = 1.5
        let width = (self.view.frame.width - horizontalSpacing) / cellsPerLine
        let height = width * aspectRatio
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if collectionView == actorsCollectionView {
            guard let searchId = actorsList[indexPath.item].id else { return }
            pushActorDetailsViewController(searchID: searchId, indexPathItem: indexPath.item)
        } else {
            guard let searchId = moviesList[indexPath.item].id else { return }
            if selectedSegmentTitle == "movie" {
                pushMovieDetailsViewController(searchId: searchId)
            }
            if selectedSegmentTitle == "tv" {
                pushTvDetailsViewController(searchId: searchId)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == moviesCollectionView {
            let verticalSpacing: CGFloat = 12
            let top = actorsCollectionView.frame.height + verticalSpacing
            return UIEdgeInsets(top: top, left: 4, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
}


// MARK: - My functions.

extension MainViewController {
    private func searchMovies() {
        if searchBar.text == "" {
            NetworkManager.shared.requestTrending(segmentTitle: selectedSegmentTitle) { moviesList in
                self.moviesList = moviesList
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
        }
        if searchBar.text != "" {
            NetworkManager.shared.requestMovies(searchBar.text!, segmentTitle: selectedSegmentTitle) { moviesList in
                self.moviesList = moviesList
            }
        }
    }
    private func searchActors() {
        NetworkManager.shared.requestActors { actorsList in
            self.actorsList = actorsList
            self.actorsCollectionView.reloadData()
        }
    }
    private func setupNavigationBar() {
        let label = UILabel()
        label.text = "The Movie Data Base"
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 24)
        label.textAlignment = .center
        label.textColor = .white
        navigationItem.titleView = label
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    private func pushMovieDetailsViewController(searchId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: MovieDetailsViewController.self)
        guard let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? MovieDetailsViewController else { return }
        NetworkManager.shared.requestDetailsForSelectedMovie(searchId) { movie in
            movieDetailsViewController.movie = movie
            self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
    private func pushTvDetailsViewController(searchId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: TvDetailsViewController.self)
        guard let tvDetailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? TvDetailsViewController else { return }
        NetworkManager.shared.requestDetailsForSelectedTV(searchId) { tv in
            tvDetailsViewController.tv = tv
            self.navigationController?.pushViewController(tvDetailsViewController, animated: true)
        }
    }
    private func pushActorDetailsViewController(searchID: Int, indexPathItem: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: ActorDetailsViewController.self)
        guard let actorDetailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? ActorDetailsViewController else { return }
        NetworkManager.shared.requestActorDetails(searchID) { actorDetails in
            actorDetailsViewController.actorDetails = actorDetails
            guard let knownFor = self.actorsList[indexPathItem].knownFor else { return }
            actorDetailsViewController.knownForList = knownFor
            self.navigationController?.pushViewController(actorDetailsViewController, animated: true)
        }
    }
}
