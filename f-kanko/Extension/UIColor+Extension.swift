//
//  UIColor+Extension.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import UIKit

extension UIColor {
    static let primary: UIColor = UIColor(hex: "#BF161A")!
    static let secondary: UIColor = UIColor(hex: "#ff5e00")!
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func applyBrightnessRatio(_ brightnessRatio: CGFloat = 0.8) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        var a: CGFloat = 0
        
        if getHue(&h, saturation: &s, brightness: &v, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: v * brightnessRatio, alpha: a)
        } else {
            return self
        }
    }
}
