//
//  TransactionRouter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import UIKit

// MARK: - TransactionWireframe
protocol TransactionWireframe: AnyObject {
}

// MARK: - TransactionRouter
final class TransactionRouter {
    private unowned let viewController: TransactionViewController

    private init(viewController: TransactionViewController) {
        self.viewController = viewController
    }

    static func assembleModules() -> TransactionViewController {
        let viewController = TransactionViewController.instance()
        let router = TransactionRouter(viewController: viewController)
        let presenter = TransactionPresenter(view: viewController, router: router)
        viewController.inject(presenter: presenter)
        return viewController
    }
}

// MARK: - TransactionWireframe Extension
extension TransactionRouter: TransactionWireframe {
}
