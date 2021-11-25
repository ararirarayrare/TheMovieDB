import UIKit

class AlertService {
    static let shared = AlertService()
    
    func alert(text: String) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.text = text
        return alertViewController
    }
    func deleteMovieAlert(completion: @escaping () -> Void) -> DeleteAlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let deleteAlertViewController = storyboard.instantiateViewController(withIdentifier: "DeleteAlertViewController") as! DeleteAlertViewController
        deleteAlertViewController.deleteAction = completion
        return deleteAlertViewController
    }
}
