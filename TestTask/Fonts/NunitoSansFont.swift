//
//  NunitoSansFont.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation
import SwiftUI

public enum NunitoSans: String, CaseIterable {
    case regular = "NunitoSans-Regular"
}

// MARK: - NunitoSansFont
public struct NunitoSansFont {
    public static func registerFonts() {
        NunitoSans.allCases.forEach {
            registerFont(bundle: .main, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName) with extension \(fontExtension)")
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        
        if let error = error?.takeRetainedValue() {
            fatalError("Failed to register font: \(error)")
        }
    }
}

// MARK: - Font
extension Font {
    public static var h1: Font = {
        return nunitoSans(.regular, size: 20)
    }()
    
    public static var p1: Font = {
        return nunitoSans(.regular, size: 16)
    }()
    
    public static var p2: Font = {
        return nunitoSans(.regular, size: 18)
    }()
    
    public static var p3: Font = {
        return nunitoSans(.regular, size: 14)
    }()
    
    public static func nunitoSans(_ font: NunitoSans, size: CGFloat) -> Font {
        return .custom(font.rawValue, size: size)
    }
}
