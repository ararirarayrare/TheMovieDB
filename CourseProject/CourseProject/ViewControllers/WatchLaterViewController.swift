import UIKit
import RealmSwift

class WatchLaterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    private var data: Results<WatchLater>!
    let alertService = AlertService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellName = String(describing: WatchLaterTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellName)
        setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = realm.objects(WatchLater.self)
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.deleteAllButton.layer.cornerRadius = 12
    }
    
    @IBAction func deleteAllButtonPressed(_ sender: UIButton) {
        if self.data.count > 0 {
        let alert = alertService.deleteAlert { [weak self] in
            if self?.data != nil {
                try! self?.realm.write({
                    self?.realm.delete(self!.data!)
                })
                self?.tableView.reloadData()
            }
        }
        present(alert, animated: true, completion: nil)
        } else {
            let alert = alertService.alert(text: "Your list is clear!\nNothing to delete")
            let when = DispatchTime.now() + 1
            present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension WatchLaterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count != 0 {
            return self.data.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchLaterTableViewCell") as? WatchLaterTableViewCell
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
            try! self.realm.write({
                self.realm.delete(editingRow)
            })
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = data[indexPath.row]
        let searchId = row.id
        if row.numberOfSeasons == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
                NetworkManager.shared.requestDetailsForSelectedMovie(searchId) { movie in
                    movieDetailsViewController.movie = movie
                    NetworkManager.shared.requestVideoDetails(searchId) { videoList in
                        movieDetailsViewController.videosList = videoList
                        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
                    }
                }
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tvDetailsViewController = storyboard.instantiateViewController(withIdentifier: "TvDetailsViewController") as? TvDetailsViewController {
                NetworkManager.shared.requestDetailsForSelectedTV(searchId) { tv in
                    tvDetailsViewController.tv = tv
                    self.navigationController?.pushViewController(tvDetailsViewController, animated: true)
                }
            }
        }
    }
}

// MARK: - My functions

extension WatchLaterViewController {
    func setupNavigationBar() {
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
}
