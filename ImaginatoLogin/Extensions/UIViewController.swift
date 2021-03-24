//
//  UIViewController.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import UIKit

extension UIViewController {
    func showMessage(title: String? = nil, message: String?) {
        let alertController = UIAlertController(title: title ?? "Imaginato", message: message, preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = "alertViewController"
        alertController.view.accessibilityValue = "\(message ?? "")"
        let closeAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
}

