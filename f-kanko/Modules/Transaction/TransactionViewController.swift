//
//  TransactionViewController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import UIKit
import Combine

// MARK: - TransactionView
protocol TransactionView: AnyObject {
}

// MARK: - TransactionViewController
final class TransactionViewController: UIViewController {
    private var cancellables = [AnyCancellable]()
    private var presenter: TransactionPresentation!

    func inject(presenter: TransactionPresentation) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - TransactionView Extension
extension TransactionViewController: TransactionView {
}
