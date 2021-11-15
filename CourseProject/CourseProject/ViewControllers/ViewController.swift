import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var mainNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    private var moviesList: [Movie] = []
    private var selectedSegmentTitle: String = "movie" {
        didSet {
           searchMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovies()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
       
        let cellName = String(describing: MovieCellTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
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

// MARK: - TableView configuration.

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCellTableViewCell", for: indexPath) as? MovieCellTableViewCell {
            cell.configureWith(moviesList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let selectedMovie = moviesList[indexPath.row]
        
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - My functions. Searching movies/tv.

extension ViewController {
    func searchMovies() {
        if searchBar.text == "" {
            NetworkManager.shared.requestTrending(segmentTitle: selectedSegmentTitle) { moviesList in
                self.moviesList = moviesList
                self.tableView.reloadData()
            }
        }
        if searchBar.text != "" {
            NetworkManager.shared.requestMovies(searchBar.text!, segmentTitle: selectedSegmentTitle) { moviesList in
                self.moviesList = moviesList
                self.tableView.reloadData()
            }
        }
    }
}
