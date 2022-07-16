//
//  NavigationController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    var logo: UIImageView!
    
    override func viewDidLoad() {
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.white
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
        
        self.logo = UIImageView(image: UIImage(named: "miketsu_logo")!)
        self.logo.contentMode = .scaleAspectFit
        self.logo.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.addSubview(self.logo)
        
        NSLayoutConstraint.activate([
            self.logo.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.logo.heightAnchor.constraint(equalToConstant: self.navigationBar.frame.height),
            self.logo.centerYAnchor.constraint(equalTo: self.navigationBar.centerYAnchor, constant: -1.0),
            self.logo.centerXAnchor.constraint(equalTo: self.navigationBar.centerXAnchor),
        ])
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
