import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var alertTextLabel: UILabel!
    
    var text = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 15
        alertTextLabel.text = text
    }
}
