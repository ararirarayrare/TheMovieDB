import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 15
    }
}
