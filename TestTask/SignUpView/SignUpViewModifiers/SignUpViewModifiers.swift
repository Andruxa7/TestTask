//
//  SignUpViewModifiers.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import Foundation
import SwiftUI

struct ModalPresentationModifier: ViewModifier {
    @Binding var showSuccessView: Bool
    @Binding var showFailedView: Bool
    let vm: SignUpViewModel
    let onSuccessfulSignUp: () -> Void
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $showSuccessView) {
                SuccessView(showSuccessView: $showSuccessView, onGotItTapped: {
                    onSuccessfulSignUp()
                })
            }
            .fullScreenCover(isPresented: $showFailedView) {
                FailedView(
                    showFailedView: $showFailedView,
                    message: vm.serverError ?? "Sign up failed with an unknown error",
                    retryAction: {
                        await vm.signUp()
                    }
                )
            }
    }
}

// Extension View to modal presentation SuccessView or FailedView
extension View {
    func modalPresentation(
        showSuccessView: Binding<Bool>,
        showFailedView: Binding<Bool>,
        vm: SignUpViewModel,
        onSuccessfulSignUp: @escaping () -> Void
    ) -> some View {
        self.modifier(ModalPresentationModifier(
            showSuccessView: showSuccessView,
            showFailedView: showFailedView,
            vm: vm,
            onSuccessfulSignUp: onSuccessfulSignUp
        ))
    }
}

// TabView visibility modifier
struct KeyboardAwareModifier: ViewModifier {
    @Binding var isVisible: Bool
    
    init(isVisible: Binding<Bool>) {
        self._isVisible = isVisible
    }

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                isVisible = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                isVisible = true
            }
    }
}

extension View {
    func keyboardAware(isVisible: Binding<Bool>) -> some View {
        self.modifier(KeyboardAwareModifier(isVisible: isVisible))
    }
}

// Extension to hide keyboard when tapping outside the TextField
extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
