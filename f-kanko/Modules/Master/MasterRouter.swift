//
//  MasterRouter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import UIKit

// MARK: - MasterWireframe
protocol MasterWireframe: AnyObject {
}

// MARK: - MasterRouter
final class MasterRouter {
    private unowned let viewController: MasterViewController

    private init(viewController: MasterViewController) {
        self.viewController = viewController
    }

    static func assembleModules() -> MasterViewController {
        let viewController = MasterViewController.instance()
        let router = MasterRouter(viewController: viewController)
        let presenter = MasterPresenter(view: viewController, router: router)
        viewController.inject(presenter: presenter)
        return viewController
    }
}

// MARK: - MasterWireframe Extension
extension MasterRouter: MasterWireframe {
}
