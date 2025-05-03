//
//  ViewModifiers.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation
import SwiftUI

struct HeadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.h1)
    }
}

struct Body1Style: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.p1)
    }
}

struct Body2Style: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.p2)
    }
}

struct Body3Style: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.p3)
    }
}

// MARK: - View
extension View {
    public func headingStyle() -> some View {
        modifier(HeadingStyle())
    }
    
    public func body1Style() -> some View {
        modifier(Body1Style())
    }
    
    public func body2Style() -> some View {
        modifier(Body2Style())
    }
    
    public func body3Style() -> some View {
        modifier(Body3Style())
    }
}
