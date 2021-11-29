import UIKit

class WatchLaterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    var data = [WatchLater]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellName = String(describing: WatchLaterTableViewCell.self)
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = DataManager.shared.get()
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.deleteAllButton.layer.cornerRadius = 12
    }
    
    @IBAction func deleteAllButtonPressed(_ sender: UIButton) {
        if self.data.count > 0 {
            let alert = AlertService.shared.deleteMovieAlert {
                self.data.removeAll()
                DataManager.shared.deleteAll()
                self.tableView.reloadData()
                let alert = AlertService.shared.alert(text: "Watch later list is cleared :)")
                let deadline = DispatchTime.now() + 0.5
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            present(alert, animated: true, completion: nil)
        } else {
            let alert = AlertService.shared.alert(text: "Your list is clear!\nNothing to delete")
            let deadline = DispatchTime.now() + 1
            present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableView configuration.

extension WatchLaterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count != 0 {
            return data.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: WatchLaterTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? WatchLaterTableViewCell
        let item = data[indexPath.row]
        cell?.configure(with: item)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let editingRow = self.data[indexPath.row]
            self.data.remove(at: indexPath.row)
            DataManager.shared.removeSelected(object: editingRow)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = data[indexPath.row]
        let searchId = row.id
        if row.numberOfSeasons == 0 {
            pushMovieDetailsViewController(searchId: searchId)
        } else {
            pushTvDetailsViewController(searchId: searchId)
        }
    }
}

// MARK: - My functions

extension WatchLaterViewController {
    private func setupNavigationBar() {
        let label = UILabel()
        label.text = "Watch later list"
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
}
