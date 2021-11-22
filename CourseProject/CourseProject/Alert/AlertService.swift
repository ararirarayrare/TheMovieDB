import UIKit

class AlertService {
    func alert() -> AlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        return alertViewController
    }
}
