//
//  CustomButton.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 09.06.2025.
//

import SwiftUI

public enum ButtonType {
    case primary
    case secondary
}

// MARK: - CustomButtonStyle
public struct CustomButtonStyle: ButtonStyle {
    private let type: ButtonType
    private let isEnabled: Bool
    
    public init(type: ButtonType, isEnabled: Bool = true) {
        self.type = type
        self.isEnabled = isEnabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        AnyView(makeButtonContent(configuration: configuration))
    }
    
    // MARK: - Button Content
    private func makeButtonContent(configuration: Configuration) -> some View {
        Group {
            switch type {
            case .primary:
                makePrimaryButton(configuration: configuration)
            case .secondary:
                makeSecondaryButton(configuration: configuration)
            }
        }
    }
    
    // MARK: - Primary Button
    private func makePrimaryButton(configuration: Configuration) -> some View {
        configuration.label
            .body2Style()
            .padding(.vertical, 12)
            .padding(.horizontal, 39)
            .foregroundStyle(primaryForegroundColor)
            .background(Capsule().fill(primaryBackgroundColor(configuration: configuration)))
    }
    
    // MARK: - Secondary Button
    private func makeSecondaryButton(configuration: Configuration) -> some View {
        configuration.label
            .body1Style()
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .foregroundStyle(secondaryForegroundColor)
            .background(Capsule().fill(secondaryBackgroundColor(configuration: configuration)))
    }
    
    // MARK: - Primary Colors
    private var primaryForegroundColor: Color {
        if !isEnabled {
            return .black_48
        }
        return .black_87
    }
    
    private func primaryBackgroundColor(configuration: Configuration) -> Color {
        if !isEnabled {
            return .primaryDisabled
        }
        return configuration.isPressed ? .primaryPressed : .primaryColor
    }
    
    // MARK: - Secondary Colors
    private var secondaryForegroundColor: Color {
        if !isEnabled {
            return .black_48
        }
        return .secondaryDarkColor
    }
    
    private func secondaryBackgroundColor(configuration: Configuration) -> Color {
        if !isEnabled {
            return .clear
        }
        return configuration.isPressed ? .secondaryPressedColor : .clear
    }
}

// MARK: - CustomButton
public struct CustomButton: View {
    private let title: String
    private let type: ButtonType
    private let action: () -> Void
    private let isEnabled: Bool
    
    public init(
        title: String,
        type: ButtonType = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: isEnabled ? action : {}) {
            Text(title)
                .body2Style()
        }
        .buttonStyle(CustomButtonStyle(type: type, isEnabled: isEnabled))
        .disabled(!isEnabled)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.extrLarge) {
            Text("Primary Buttons")
                .headingStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: Spacing.large) {
                CustomButton(title: "Normal", type: .primary) {}
                CustomButton(title: "Pressed", type: .primary) {}
                    .simultaneousGesture(DragGesture(minimumDistance: 0))
                CustomButton(title: "Disabled", type: .primary, isEnabled: false) {}
            }
            
            Text("Secondary Buttons")
                .headingStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: Spacing.large) {
                CustomButton(title: "Normal", type: .secondary) {}
                CustomButton(title: "Pressed", type: .secondary) {}
                    .simultaneousGesture(DragGesture(minimumDistance: 0))
                CustomButton(title: "Disabled", type: .secondary, isEnabled: false) {}
            }
        }
        .padding()
        .background(Color.backgroundColor)
        .previewLayout(.sizeThatFits)
    }
}
