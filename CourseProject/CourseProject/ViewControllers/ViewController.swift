import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var mainNavigationItem: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var moviesList: [Movie] = []
    private var selectedSegmentTitle: String = "movie" {
        didSet {
           searchMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovies()
        setupNavigationBar()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        let cellName = String(describing: MovieCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMovies()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMovies()
        self.view.endEditing(true)
    }
}

// MARK: - CollectionView configuration.

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
            
            cell.configure(with: moviesList[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 16) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let selectedMovie = moviesList[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            var genres: [String] = []
            for item in selectedMovie.genre_ids! {
                let genresList = NetworkManager.shared.genresId[item]
                genres.append(genresList ?? "")
            }
            detailsViewController.genres = genres
            detailsViewController.movie = selectedMovie
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
    

// MARK: - My functions.

extension ViewController {
    func searchMovies() {
        if searchBar.text == "" {
            NetworkManager.shared.requestTrending(segmentTitle: selectedSegmentTitle) { moviesList in
                self.moviesList = moviesList
                self.collectionView.reloadData()
            }
        }
        if searchBar.text != "" {
            NetworkManager.shared.requestMovies(searchBar.text!, segmentTitle: selectedSegmentTitle) { moviesList in
                self.moviesList = moviesList
                self.collectionView.reloadData()
            }
        }
    }
    func setupNavigationBar() {
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
}
