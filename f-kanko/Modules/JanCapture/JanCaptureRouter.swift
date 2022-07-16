//
//  JanCaptureRouter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import UIKit

protocol JanCaptureWireframe: AnyObject {

}

final class JanCaptureRouter {
    private unowned let viewController: JanCaptureViewController

    private init(viewController: JanCaptureViewController) {
        self.viewController = viewController
    }

    static func assebleModules(onComplete: @escaping (Result<String, Never>) -> Void) -> JanCaptureViewController {
        let view = JanCaptureViewController()
        let router = JanCaptureRouter(viewController: view)
        let presenter = JanCapturePresenter(view: view, router: router, onComplete: onComplete)
        view.inject(presenter: presenter)
        return view
    }
}

extension JanCaptureRouter: JanCaptureWireframe {

}
