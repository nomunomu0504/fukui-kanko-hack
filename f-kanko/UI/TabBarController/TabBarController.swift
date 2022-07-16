//
//  TabBarController.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.primary
        
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor(hex: "#b0b0b0")
        self.tabBar.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.widthAnchor.constraint(equalTo: self.tabBar.widthAnchor),
            border.heightAnchor.constraint(equalToConstant: 0.2),
            border.topAnchor.constraint(equalTo: self.tabBar.topAnchor),
        ])
    }
}
