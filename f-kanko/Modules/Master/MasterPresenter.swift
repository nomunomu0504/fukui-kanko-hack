//
//  MasterPresenter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import Foundation
import Combine

// MARK: - MasterPresentation
protocol MasterPresentation: AnyObject {
}

// MARK: - MasterPresenter
final class MasterPresenter {
    private var cancellables = [AnyCancellable]()
    private weak var view: MasterView?
    private let router: MasterRouter

    init(view: MasterView, router: MasterRouter) {
        self.view = view
        self.router = router
    }
}

// MARK: - MasterPresentation Extension
extension MasterPresenter: MasterPresentation {
}
