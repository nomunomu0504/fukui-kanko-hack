//
//  MasterViewController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import UIKit
import Combine

// MARK: - MasterView
protocol MasterView: AnyObject {
}

// MARK: - MasterViewController
final class MasterViewController: UIViewController {
    private var cancellables = [AnyCancellable]()
    private var presenter: MasterPresentation!

    func inject(presenter: MasterPresentation) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - MasterView Extension
extension MasterViewController: MasterView {
}
