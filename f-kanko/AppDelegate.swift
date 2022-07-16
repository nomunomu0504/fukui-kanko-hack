//
//  AppDelegate.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit
import Firebase
import PermissionsKit
import CameraPermission
import NotificationPermission

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        // 同時タップ制御
        UIView.appearance().isExclusiveTouch = true
        
        // 画面起動
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = LoginRouter.assebleModules()
//        let topViewController = TopRouter.assebleModules()
//        let navigationController = NavigationController(
//            rootViewController: topViewController
//        )
//        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        Permission.camera.request {}
        Permission.notification.request {}
        return true
    }


}

