//
//  TopPresenter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation
import Combine
import CombineCocoa

protocol TopPresentation: AnyObject {
    var onTappedTestButtonTrigger: PassthroughSubject<(Result<String, Never>) -> Void, Never> { get }
    var doPayment: PassthroughSubject<(UserInfo, Int, (Result<Void, Error>) -> Void), Never> { get }
}

final class TopPresenter {
    var onTappedTestButtonTrigger = PassthroughSubject<(Result<String, Never>) -> Void, Never>()
    var doPayment = PassthroughSubject<(UserInfo, Int, (Result<Void, Error>) -> Void), Never>()

    private var cancellables = [AnyCancellable]()
    private weak var view: TopView?
    private let router: TopRouter
    private let paymentInteractory: PaymentInteractor

    init(view: TopView, router: TopRouter, paymentInteractor: PaymentInteractor) {
        self.view = view
        self.router = router
        self.paymentInteractory = paymentInteractor
        self.onTappedTestButtonTrigger
            .sink { [weak self] onComplete in
                guard let self = self else { return }
                self.router.presentJanCapture(onComplete: onComplete)
            }
            .store(in: &cancellables)
        
        self.doPayment
            .sink { [weak self] params in
                let userInfo = params.0
                let price = params.1
                let onComplete = params.2
                
                guard let self = self else { return }
                self.paymentInteractory.doPay(
                    userId: userInfo.uid,
                    price: price,
                    onComplete: onComplete
                )
            }
            .store(in: &cancellables)
    }
}

extension TopPresenter: TopPresentation {

}
