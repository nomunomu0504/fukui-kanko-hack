//
//  UIAlertController+Extension.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation
import UIKit

protocol UIAlertControllerProtocol {}

extension UIAlertController: UIAlertControllerProtocol {}

extension UIAlertControllerProtocol where Self: UIViewController {
    static func showAlert(
        title: String,
        message: String,
        positiveButtonText: String,
        onDismiss: (() -> Void)? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: positiveButtonText, style: .default) { _ in
            if let onDismiss = onDismiss {
                onDismiss()
            }
        }
        alert.addAction(action)
        return alert
    }
    
    static func showConfirm(
        title: String,
        message: String,
        negativeButtonText: String,
        positiveButtonText: String,
        onDismiss: @escaping (Bool) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let negativeAction = UIAlertAction(title: negativeButtonText, style: .destructive) { _ in
            onDismiss(false)
        }
        let positiveAction = UIAlertAction(title: positiveButtonText, style: .default) { _ in
            onDismiss(true)
        }
        alert.addAction(negativeAction)
        alert.addAction(positiveAction)
        return alert
    }
}

extension UIAlertControllerProtocol where Self: UIView {
    static func showAlert(
        title: String,
        message: String,
        positiveButtonText: String,
        onDismiss: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: positiveButtonText, style: .default) { _ in
            if let onDismiss = onDismiss {
                onDismiss()
            }
        }
        alert.addAction(action)
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController?.present(alert, animated: true)
    }
    
    static func showConfirm(
        title: String,
        message: String,
        negativeButtonText: String,
        positiveButtonText: String,
        onDismiss: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let negativeAction = UIAlertAction(title: negativeButtonText, style: .destructive) { _ in
            onDismiss(false)
        }
        let positiveAction = UIAlertAction(title: positiveButtonText, style: .default) { _ in
            onDismiss(true)
        }
        alert.addAction(negativeAction)
        alert.addAction(positiveAction)
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController?.present(alert, animated: true)
    }
}
