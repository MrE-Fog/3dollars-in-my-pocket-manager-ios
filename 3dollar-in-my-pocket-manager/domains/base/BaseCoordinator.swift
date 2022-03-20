import UIKit
import Base

protocol BaseCoordinator {
    var presenter: BaseViewController { get }
    
    func showErrorAlert(error: Error)
    func openURL(url: String)
}

extension BaseCoordinator where Self: BaseViewController {
    var presenter: BaseViewController {
        return self
    }
    
    
    func showErrorAlert(error: Error) {
        AlertUtils.showWithAction(
            viewController: self,
            message: error.localizedDescription,
            onTapOk: nil
        )
    }
    
    func openURL(url: String) {
        guard let url = URL(string: url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
