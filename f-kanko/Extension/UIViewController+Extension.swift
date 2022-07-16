//
//  UIViewController+Extension.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation
import UIKit
import PKHUD
import SwiftyGif

/// UIViewControllerProtocol
protocol UIViewControllerProtocol {}

/// UIViewController Extension
extension UIViewController: UIViewControllerProtocol {}

/// 対象のオブジェクトがUIViewControllerのときだけ有効
extension UIViewControllerProtocol where Self: UIViewController {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    /// クラスからStoryBoardインスタンスを生成
    static func instance() -> Self {
        let storyboard: UIStoryboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not find storyboard or initialize viewController.")
        }
        
        return viewController
    }
    
    /// ローディング表示
    func showProgress() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        PKHUD.sharedHUD.contentView = PKHUDLoadingView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        PKHUD.sharedHUD.show(onView: window)
        
    }
    
    /// ローディング非表示
    func hideProgress(onCompletion: @escaping (() -> Void)) {
        PKHUD.sharedHUD.hide { _ in
            onCompletion()
            return
        }
    }
}

final class PKHUDLoadingView: PKHUDSquareBaseView, PKHUDAnimating {
    
    func startAnimation() {
        do {
            let gif = try UIImage(gifName: "loading.gif")
            let imageView = UIImageView(gifImage: gif, loopCount: -1)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.insertSubview(imageView, at: 0)
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        } catch {
            print(error)
        }
    }
}

