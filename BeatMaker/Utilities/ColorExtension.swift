//
//  ColorExtension.swift
//  BeatMaker
//
//  Created by Nik Y on 21.03.2024.
//

import SwiftUI

extension Color {
    static let backgroundColor = Color("backgroundColor")
    static let onBackgroundColorColor = Color("onBackgroundColor")
}
    
extension Color {
    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        
        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        self.init(.sRGB, red: Double(red) / 0xff, green: Double(green) / 0xff, blue:  Double(blue) / 0xff, opacity: alpha)
    }
}
