//
//  App Language.swift
//  iNet
//
//  Created by Saba Gogrichiani on 05.02.24.
//

import SwiftUI

enum AppFont: String {
    case boldEnglish = "Poppins-Bold"
    case semiboldEnglish = "Poppins-Semibold"
    case mediumEnglish = "Poppins-Medium"
    case regularEnglish = "Poppins-Regular"
    
    case boldGeorgian = "NotoSansGeorgian-Bold"
    case semiboldGeorgian = "NotoSansGeorgian-Semibold"
    case mediumGeorgian = "NotoSansGeorgian-Medium"
    case regularGeorgian = "NotoSansGeorgian-Regular"
    
    func font(size: CGFloat) -> Font {
        return .custom(self.rawValue, size: size)
    }
    
    func uiFont(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func forLanguage(_ languageCode: String, style: FontStyle) -> AppFont {
        switch languageCode {
        case "ge":
            switch style {
            case .bold:
                return .boldGeorgian
            case .semibold:
                return .semiboldGeorgian
            case .medium:
                return .mediumGeorgian
            case .regular:
                return .regularGeorgian
            }
        default:
            switch style {
            case .bold:
                return .boldEnglish
            case .semibold:
                return .semiboldEnglish
            case .medium:
                return .mediumEnglish
            case .regular:
                return .regularEnglish
            }
        }
    }
}

enum FontStyle {
    case bold, semibold, medium, regular
}
