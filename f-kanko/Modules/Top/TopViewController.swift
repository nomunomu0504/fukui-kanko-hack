//
//  TopViewController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit
import AVFoundation
import Combine
import CombineCocoa

// MARK: - TopView
protocol TopView: AnyObject {

}

// MARK: - TopViewController
final class TopViewController: UIViewController {
    private var presenter: TopPresentation!
    
    private var cancellables = [AnyCancellable]()
    private var player: AVAudioPlayer?
    
    @IBOutlet weak var testPrice: UITextField!
    @IBOutlet weak var testTextView: UITextView!
    @IBOutlet weak var testButton: UIButton!
    
    func inject(presenter: TopPresentation) {
        self.presenter = presenter
    }
    
    func doPaymentHandler(_ result: Result<Void, Error>) {
        switch (result) {
        case .success(_):
            if let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
                do {
                    self.player = try AVAudioPlayer(contentsOf: soundURL)
                    self.player?.play()
                } catch {
                    print("error")
                }
            }
            self.presentAlert(.showAlert(
                title: "支払い完了",
                message: "お支払いが完了しました。",
                positiveButtonText: "閉じる"
            ))
        case .failure(let error):
            self.presentAlert(.showAlert(
                title: "エラーが発生しました",
                message: error.localizedDescription,
                positiveButtonText: "閉じる"
            ))
        }
    }
    
    func test(_ result: Result<String, Never>) {
        self.showProgress()
        do {
            if case .failure(let error) = result {
                self.presentAlert(.showAlert(
                    title: "エラーが発生しました",
                    message: error.localizedDescription,
                    positiveButtonText: "閉じる"
                ))
                return
            }
            
            if case .success(let janCode) = result {
                self.testTextView.text = janCode
                let userInfo = try JSONDecoder().decode(
                    UserInfo.self,
                    from: janCode.data(using: .utf8)!
                )
                self.presenter
                    .doPayment
                    .send((userInfo, Int(self.testPrice.text!)!, self.doPaymentHandler))
            }
            
            self.hideProgress {}
        } catch {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testTextView.text = ""
        self.testPrice
            .textPublisher
            .sink { [weak self] text in
                guard
                    let self = self,
                    let price = text
                else { return }
                
                self.testButton.isEnabled = !price.isEmpty
            }
            .store(in: &cancellables)
        
        
        self.testButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.presenter.onTappedTestButtonTrigger.send(self.test)
            }
            .store(in: &cancellables)
    }
}

// MARK: - TopViewController Extension
extension TopViewController: TopView {

}
