//
//  JanCaptureViewController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/15.
//

import UIKit
import AVFoundation
import Combine
import CombineCocoa

// MARK: - JanCaptureView
protocol JanCaptureView: AnyObject {
    var closeJanCaptureViewTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - JanCaptureViewController
final class JanCaptureViewController: UIViewController {
    var closeJanCaptureViewTrigger = PassthroughSubject<Void, Never>()
    
    private var presenter: JanCapturePresentation!
    private var cancellables = [AnyCancellable]()

    func inject(presenter: JanCapturePresentation) {
        self.presenter = presenter
    }
    
    /// 変数定義
    let detectionAreaView = UIView()
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var janCode: String?
    
    /// 検出エリアカスタマイズ
    let x: CGFloat = 0.25
    let y: CGFloat = 0.4
    let width: CGFloat = 0.5
    let height: CGFloat = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .done,
            target: self,
            action: #selector(navigationLeftButtonTapped)
        )
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
        self.bind()

        self.startJanCapture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 検出エリア表示
        self.detectionAreaView.frame = CGRect(
            x: view.frame.size.width * self.x,
            y: view.frame.size.height * self.y,
            width: view.frame.size.width * self.width,
            height: view.frame.size.height * self.height
        )
        self.detectionAreaView.layer.borderColor = UIColor.red.cgColor
        self.detectionAreaView.layer.borderWidth = 4
        self.detectionAreaView.layer.cornerRadius = 6
        self.detectionAreaView.clipsToBounds = true
        self.view.addSubview(self.detectionAreaView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.captureSession?.stopRunning()
        self.captureSession = nil
    }
    
    /// ナビゲーション左ボタンタップ
    @objc private func navigationLeftButtonTapped() {
        self.presenter.onTappedNavigationBarLeftTrigger.send()
    }
    
    /// JANコードキャプチャ
    func startJanCapture() {
        // 画像や動画といった出力データの管理を行うクラス
        let session = AVCaptureSession()

        guard
            // カメラデバイスの管理を行うクラス
            let device: AVCaptureDevice = AVCaptureDevice.default(for: .video),
            // AVCaptureDeviceをAVCaptureSessionに渡すためのクラス
            let input: AVCaptureInput = try? AVCaptureDeviceInput(device: device)
        else { return }

        // inputをセッションに追加
        session.addInput(input)

        // outputをセッションに追加
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)

        // 取得したメタデータを置くAVCaptureMetadataOutputの設定(delegateの設定)
        output.setMetadataObjectsDelegate(self, queue: .main)

        // 取得したメタデータを置くAVCaptureMetadataOutputの設定
        // JANコードの場合はean8とean13、他にもqrやcode93などがある
        output.metadataObjectTypes = [.qr]

        // バーコードの検出エリアの設定（設定しない場合、画面全体が検出エリアになる）
        output.rectOfInterest = CGRect(
            x: self.y,
            y: 1 - self.x - width,
            width: self.height,
            height: self.width
        )

        // セッションを開始
        session.startRunning()

        // 画面上にカメラの映像を表示するためにvideoLayerを作る
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = self.view.bounds

        // videoPreviewLayerを最初に宣言した定数に追加する
        self.videoPreviewLayer = videoPreviewLayer
        self.view.layer.addSublayer(videoPreviewLayer)

        // 開放用に保持
        self.captureSession = session
    }
    
    /// JANコードキャプチャ終了
    func stopJanCapture() {
        self.captureSession?.stopRunning()
        self.captureSession = nil
        self.presenter.onFinishedJanCapture.send(self.janCode)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension JanCaptureViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        // バーコード検出時
        for metadataObject in metadataObjects {
            guard
                self.videoPreviewLayer?.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject,
                let object = metadataObject as? AVMetadataMachineReadableCodeObject,
                let detectionString = object.stringValue
            else { continue }
            
            Logger.debug("captured QR: \(detectionString)")
            self.janCode = detectionString
            
            if detectionString.starts(with: "4") && detectionString.count == 13 {
                Logger.debug("captured JanCode: \(detectionString)")
                self.janCode = detectionString
            }
        }
        
        if self.janCode != nil {
            self.stopJanCapture()
        }
    }
}

// MARK: - JanCaptureViewController Extension
extension JanCaptureViewController: JanCaptureView {
    private func bind() {
        self.closeJanCaptureViewTrigger
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}
