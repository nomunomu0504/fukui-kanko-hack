//
//  TopRouter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit
import Combine
import CombineCocoa

protocol TopWireframe: AnyObject {
    func presentJanCapture(onComplete: @escaping (Result<String, Never>) -> Void)
}

final class TopRouter {
    private unowned let viewController: TopViewController

    private init(viewController: TopViewController) {
        self.viewController = viewController
    }

    static func assebleModules() -> TopViewController {
        let view = TopViewController.instance()
        let router = TopRouter(viewController: view)
        let paymentInteractor = PaymentInteractor(
            firebaseRemoteRepository: FirebaseRemoteRepositoryImpl(),
            loginInfoLocalRepository: LoginInfoLocalRepositoryImpl()
        )
        let presenter = TopPresenter(
            view: view,
            router: router,
            paymentInteractor: paymentInteractor
        )
        view.inject(presenter: presenter)
        return view
    }
}

extension TopRouter: TopWireframe {
    func presentJanCapture(onComplete: @escaping (Result<String, Never>) -> Void) {
        self.viewController.navigationController?.pushViewController(
            JanCaptureRouter.assebleModules(onComplete: onComplete),
            animated: true
        )
    }
}
