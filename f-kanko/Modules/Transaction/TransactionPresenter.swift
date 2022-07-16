//
//  TransactionPresenter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import Foundation
import Combine

// MARK: - TransactionPresentation
protocol TransactionPresentation: AnyObject {
}

// MARK: - TransactionPresenter
final class TransactionPresenter {
    private var cancellables = [AnyCancellable]()
    private weak var view: TransactionView?
    private let router: TransactionRouter

    init(view: TransactionView, router: TransactionRouter) {
        self.view = view
        self.router = router
    }
}

// MARK: - TransactionPresentation Extension
extension TransactionPresenter: TransactionPresentation {
}
