import UIKit

class DeleteAlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteAllButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        deleteAction?()
    }
}
