//
//  FirebaseRemoteRepository.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FirebaseRemoteRepository: AnyObject {
    func signIn(
        email: String,
        password: String,
        onComplete: @escaping (Result<LoginInfo, Error>) -> Void
    )
    func signOut(onComplete: @escaping (Result<Void, Error>) -> Void)
    func doPay(
        storeId: String,
        paymentHistory: PaymentHistory,
        onComplete: @escaping (Result<Void, Error>) -> Void
    )
}

final class FirebaseRemoteRepositoryImpl: FirebaseRemoteRepository {
    private let firestore: Firestore = Firestore.firestore()

    func signIn(
        email: String,
        password: String,
        onComplete: @escaping (Result<LoginInfo, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let result = authResult {
                onComplete(.success(
                    LoginInfo(
                        uid: result.user.uid,
                        email: result.user.email!
                    )
                ))
            } else {
                if let error = error {
                    onComplete(.failure(error))
                } else {
                    onComplete(.failure(AppError.unknown))
                }
            }
        }
    }
    
    func signOut(onComplete: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            onComplete(.success(()))
        } catch {
            onComplete(.failure(error))
        }
    }
    
    func doPay(
        storeId: String,
        paymentHistory: PaymentHistory,
        onComplete: @escaping (Result<Void, Error>) -> Void
    ) {
        self.firestore
            .collection("StoreMaster")
            .document(storeId)
            .collection("PaymentHistory")
            .document()
            .setData(paymentHistory.toHash()) { error in
                if let error = error {
                    onComplete(.failure(error))
                    return
                }
                onComplete(.success(()))
            }
    }
}
