//
//  AuthInteractor.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation

protocol AuthUseCase: AnyObject {
    func login(
        email: String,
        password: String,
        onComplete: @escaping (Result<Void, Error>) -> Void
    )
    func logout(onComplete: @escaping (Result<Void, Error>) -> Void)
}

final class AuthInteractor {
    private let firebaseRemoteRepository: FirebaseRemoteRepository
    private let loginInfoLocalRepository: LoginInfoLocalRepository
    
    init(
        firebaseRemoteRepository: FirebaseRemoteRepository,
        loginInfoLocalRepository: LoginInfoLocalRepository
    ) {
        self.firebaseRemoteRepository = firebaseRemoteRepository
        self.loginInfoLocalRepository = loginInfoLocalRepository
    }
}

extension AuthInteractor: AuthUseCase {
    func login(
        email: String,
        password: String,
        onComplete: @escaping (Result<Void, Error>) -> Void
    ) {
        self.firebaseRemoteRepository.signIn(
            email: email,
            password: password
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loginInfo):
                self.loginInfoLocalRepository.save(loginInfo: loginInfo)
                onComplete(.success(()))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
    
    func logout(onComplete: @escaping (Result<Void, Error>) -> Void) {
        self.firebaseRemoteRepository.signOut() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loginInfo):
                self.loginInfoLocalRepository.delete()
                onComplete(.success(()))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
}
