//
//  JanCapturePresenter.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import Foundation
import Combine
import CombineCocoa

protocol JanCapturePresentation: AnyObject {
    var onTappedNavigationBarLeftTrigger: PassthroughSubject<Void, Never> { get }
    var onFinishedJanCapture: PassthroughSubject<String?, Never> { get }
}

final class JanCapturePresenter {
    
    var onTappedNavigationBarLeftTrigger = PassthroughSubject<Void, Never>()
    var onFinishedJanCapture = PassthroughSubject<String?, Never>()
    
    private weak var view: JanCaptureView?
    private let router: JanCaptureRouter
    private let onComplete: (Result<String, Never>) -> Void
    
    private var cancellables = [AnyCancellable]()

    init(
        view: JanCaptureView,
        router: JanCaptureRouter,
        onComplete: @escaping (Result<String, Never>) -> Void
    ) {
        self.view = view
        self.router = router
        self.onComplete = onComplete
        self.bind()
    }
}

extension JanCapturePresenter: JanCapturePresentation {
    private func bind() {
        self.onTappedNavigationBarLeftTrigger
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.view?.closeJanCaptureViewTrigger.send()
            }
            .store(in: &cancellables)
        
        self.onFinishedJanCapture
            .sink { [weak self] janCode in
                guard let self = self else { return }
                if let janCode = janCode {
                    self.onComplete(.success(janCode))
                }
                self.view?.closeJanCaptureViewTrigger.send()
            }
            .store(in: &cancellables)
    }
}
