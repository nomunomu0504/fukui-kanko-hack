//
//  LoginRouter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit

protocol LoginWireframe: AnyObject {
    
}

final class LoginRouter {
    private unowned let viewController: LoginViewController
    
    private init(viewController: LoginViewController) {
        self.viewController = viewController
    }
    
    static func assebleModules() -> LoginViewController {
        let view = LoginViewController.instance()
        let router = LoginRouter(viewController: view)
        let firebaseRemoteRepository = FirebaseRemoteRepositoryImpl()
        let loginInfoLocalRepository = LoginInfoLocalRepositoryImpl()
        let authInteractor = AuthInteractor(
            firebaseRemoteRepository: firebaseRemoteRepository,
            loginInfoLocalRepository: loginInfoLocalRepository
        )
        let presenter = LoginPresenter(
            view: view,
            router: router,
            authInteractor: authInteractor
        )
        view.inject(presenter: presenter)
        
        return view
    }
}

extension LoginRouter: LoginWireframe {}
