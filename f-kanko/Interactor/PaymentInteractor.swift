//
//  PaymentInteractor.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/16.
//

import Foundation

// MARK: - PaymentUseCase
protocol PaymentUseCase: AnyObject {
    func doPay(
        userId: String,
        price: Int,
        onComplete: @escaping (Result<Void, Error>) -> Void
    );
}

// MARK: - PaymentInteractor
final class PaymentInteractor {
    private let loginInfoLocalRepository: LoginInfoLocalRepository
    private let firebaseRemoteRepository: FirebaseRemoteRepository
    
    init(
        firebaseRemoteRepository: FirebaseRemoteRepository,
        loginInfoLocalRepository: LoginInfoLocalRepository
    ) {
        self.firebaseRemoteRepository = firebaseRemoteRepository
        self.loginInfoLocalRepository = loginInfoLocalRepository
    }
}

// MARK: - PaymentUseCase Extension
extension PaymentInteractor: PaymentUseCase {
    func doPay(
        userId: String,
        price: Int,
        onComplete: @escaping (Result<Void, Error>) -> Void
    ) {
        let loginInfo = self.loginInfoLocalRepository.get()
        guard let loginInfo = loginInfo else {
            onComplete(.failure(AppError.userInfoIsNotSet))
            return
        }
        
        let paymentHistory = PaymentHistory(
            userId: userId,
            amount: price,
            isRefunded: false
        )
        
        self.firebaseRemoteRepository.doPay(
            storeId: loginInfo.uid,
            paymentHistory: paymentHistory
        ) { result in
            if case .failure(let error) = result {
                onComplete(.failure(error))
                return
            }
            
            onComplete(.success(()))
        }
    }
}
