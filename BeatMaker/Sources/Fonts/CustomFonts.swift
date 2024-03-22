//
//  CustomFonts.swift
//  BeatMaker
//
//  Created by Печик Ирина on 22.03.2024.
//

import SwiftUI

enum CustomFonts: String {
    case accentTitle = "Manrope-Bold"
    case subtitle = "Manrope-Light"
}

extension Font {
    fileprivate static func custom(_ customFont: CustomFonts, size: CGFloat) -> Font {
        Font.custom(customFont.rawValue, size: size)
    }
}

extension Text {
    func font(customFont: CustomFonts, size: CGFloat) -> Text {
        self.font(Font.custom(customFont, size: size))
    }
}
