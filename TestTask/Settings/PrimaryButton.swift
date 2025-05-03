//
//  PrimaryButton.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation
import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .body2Style()
            .padding(Spacing.medium)
            .background(Capsule().fill(Color.primary))
            .foregroundColor(.black)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - ButtonStyle
extension ButtonStyle where Self == PrimaryButtonStyle {
    public static var primary: Self { Self() }
}
