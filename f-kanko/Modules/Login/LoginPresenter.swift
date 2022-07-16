//
//  LoginPresenter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation
import Combine
import UIKit

protocol LoginPresentation: AnyObject {
    var viewDidLoadTrigger: PassthroughSubject<Void, Never> { get }
    var emailTextTrigger: CurrentValueSubject<String, Never> { get }
    var passwordTextTrigger: CurrentValueSubject<String, Never> { get }
    var onTappedLoginTrigger: PassthroughSubject<Void, Never> { get }
}

final class LoginPresenter {
    // MARK: - Inputs
    var viewDidLoadTrigger = PassthroughSubject<Void, Never>()
    var emailTextTrigger = CurrentValueSubject<String, Never>("")
    var passwordTextTrigger = CurrentValueSubject<String, Never>("")
    var onTappedLoginTrigger = PassthroughSubject<Void, Never>()
    
    private weak var view: LoginView?
    private let router: LoginWireframe
    private let authInteractor: AuthUseCase
    
    private var cancellables = [AnyCancellable]()
    
    /// 初期化
    init(
        view: LoginView,
        router: LoginWireframe,
        authInteractor: AuthUseCase
    ) {
        self.view = view
        self.router = router
        self.authInteractor = authInteractor
        self.bind()
    }
}

extension LoginPresenter: LoginPresentation {
    private func bind() {
        Publishers.CombineLatest(
            self.emailTextTrigger,
            self.passwordTextTrigger
        )
        .map { $0 != "" && $1 != "" }
        .sink { [weak self] isEnabled in
            guard let self = self else { return }
//            self.view?.isEnabledLoginButton.send(isEnabled)
        }
        .store(in: &cancellables)
        
        self.onTappedLoginTrigger
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.view?.showLoading.send()
                self.authInteractor.login(
//                    email: self.emailTextTrigger.value,
//                    password: self.passwordTextTrigger.value
                    email: "teststore@localhost.com",
                    password: "teststore"
                ) { result in
                    self.view?.hideLoading.send {
                        switch result {
                        case .success():
                            self.view?.presentTop.send()
                        case .failure(let error):
                            let nsError = error as NSError
                            Logger.error("error login.", nsError)
                            self.view?.showAlert(
                                title: "ログインに失敗しました",
                                message: "メールアドレス／パスワードが不正です。",
                                positiveButtonText: "閉じる"
                            ) {
                                // do nothing
                            }
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
}
