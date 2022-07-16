//
//  LoginViewController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit
import Combine
import CombineCocoa

protocol LoginView: AnyObject {
    var showLoading: PassthroughSubject<Void, Never> { get }
    var hideLoading: PassthroughSubject<(() -> Void), Never> { get }
    var isEnabledLoginButton: CurrentValueSubject<Bool, Never> { get }
    var presentTop: PassthroughSubject<Void, Never> { get }
    func showAlert(
        title: String,
        message: String,
        positiveButtonText: String,
        onDismiss: (() -> Void)?
    )
    func showConfirm(
        title: String,
        message: String,
        negativeButtonText: String,
        positiveButtonText: String,
        onDismiss: @escaping (Bool) -> Void
    )
}

final class LoginViewController: UIViewController {
    // MARK: - Inputs
    var showLoading = PassthroughSubject<Void, Never>()
    var hideLoading = PassthroughSubject<(() -> Void), Never>()
    var isEnabledLoginButton = CurrentValueSubject<Bool, Never>(true)
    var presentTop = PassthroughSubject<Void, Never>()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func onTappedLogin(_ sender: UIButton) {
        self.presenter.onTappedLoginTrigger.send()
    }
    
    /// presenter
    private var presenter: LoginPresentation!
    
    private var cancellables = [AnyCancellable]()
    
    /// presenter注入
    func inject(presenter: LoginPresentation) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
}

extension LoginViewController: LoginView {
    private func bind() {
        self.showLoading
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.showProgress()
            })
            .store(in: &cancellables)
        
        self.hideLoading
            .sink(receiveValue: { [weak self] onCompletion in
                guard let self = self else { return }
                self.hideProgress(onCompletion: onCompletion)
            })
            .store(in: &cancellables)
        
        self.emailField.textPublisher
            .replaceNil(with: "")
            .sink { [weak self] text in
                guard let self = self else { return }
                self.presenter.emailTextTrigger.send(text)
            }
            .store(in: &cancellables)
        
        self.passwordFiled.textPublisher
            .replaceNil(with: "")
            .sink { [weak self] text in
                guard let self = self else { return }
                self.presenter.passwordTextTrigger.send(text)
            }
            .store(in: &cancellables)
        
        self.isEnabledLoginButton
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                self.loginButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        self.presentTop
            .sink { _ in
                guard
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first
                else { return }
                let topViewController = TopRouter.assebleModules()
                let navigationController = NavigationController(
                    rootViewController: topViewController
                )
                if window.rootViewController?.presentedViewController != nil {
                    window.rootViewController?.dismiss(animated: false) {
                        window.rootViewController = navigationController
                    }
                } else {
                    window.rootViewController = navigationController
                }
                
            }
            .store(in: &cancellables)
    }
    
    func showAlert(
        title: String,
        message: String,
        positiveButtonText: String,
        onDismiss: (() -> Void)? = nil
    ) {
        self.presentAlert(.showAlert(
            title: title,
            message: message,
            positiveButtonText: positiveButtonText,
            onDismiss: onDismiss
        ))
    }
    
    func showConfirm(
        title: String,
        message: String,
        negativeButtonText: String,
        positiveButtonText: String,
        onDismiss: @escaping (Bool) -> Void
    ) {
        self.presentAlert(.showConfirm(
            title: title,
            message: message,
            negativeButtonText: negativeButtonText,
            positiveButtonText: positiveButtonText,
            onDismiss: onDismiss
        ))
    }
}
