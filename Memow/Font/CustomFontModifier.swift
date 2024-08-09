//
//  CustomFontStyle.swift
//  Memow
//
//  Created by jaewon Lee on 8/5/24.
//

import SwiftUI

enum FontName: String {
    case appleSDGothicNeoR = "AppleSDGothicNeoR"
}

enum CustomFontStyle {
    case heading
    case body
    case label
    case caption

    func font(fontName: FontName) -> Font{
        switch self {
        case .heading:
            return Font.custom(fontName.rawValue, size: 16)
        case .body:
            return Font.custom(fontName.rawValue, size: 14)
        case .label:
            return Font.custom(fontName.rawValue, size: 12)
        case .caption:
            return Font.custom(fontName.rawValue, size: 8)
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .heading:
            return 24
        case .body:
            return 22
        case .label:
            return 20
        case .caption:
            return 18
        }
    }

    var kerning: CGFloat {
        switch self {
        case .heading, .body:
            return -0.004
        case .label, .caption:
            return 0.0
        }
    }
}

struct CustomFontModifier: ViewModifier {
    let style: CustomFontStyle
    let fontName: FontName

    func body(content: Content) -> some View {
        content
            .font(style.font(fontName: fontName))
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

extension View {
    func customFontStyle(
        _ style: CustomFontStyle,
        fontName: FontName = .appleSDGothicNeoR
    ) -> some View {
        self.modifier(CustomFontModifier(style: style, fontName: fontName))
    }
}
