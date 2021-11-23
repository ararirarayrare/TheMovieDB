import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var mainNavigationItem: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var resultsList: [Result] = []
    private var selectedSegmentTitle: String = "movie" {
        didSet {
            searchResults()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults()
        setupNavigationBar()
        activityIndicator.isHidden = true
        let cellName = String(describing: MainPageCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MainPageCollectionViewCell")
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
        let when = DispatchTime.now() + 1
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.searchResults()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResults()
        self.view.endEditing(true)
    }
}

// MARK: - CollectionView configuration.

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageCollectionViewCell", for: indexPath) as? MainPageCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: resultsList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 24) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        guard let searchId = resultsList[indexPath.item].id else { return }
        if selectedSegmentTitle == "movie" {
            pushMovieDetailsViewController(searchId: searchId)
        }
        if selectedSegmentTitle == "tv" {
            pushTvDetailsViewController(searchId: searchId)
        }
    }
}

// MARK: - My functions.

extension MainViewController {
    private func searchResults() {
        if searchBar.text == "" {
            NetworkManager.shared.requestTrending(segmentTitle: selectedSegmentTitle) { resultsList in
                self.resultsList = resultsList
                self.collectionView.reloadData()
            }
        }
        if searchBar.text != "" {
            NetworkManager.shared.requestMovies(searchBar.text!, segmentTitle: selectedSegmentTitle) { resultsList in
                self.resultsList = resultsList 
                self.collectionView.reloadData()
            }
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

