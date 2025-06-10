//
//  CustomUsernameTextField.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct CustomUsernameTextField: View {
    @Binding var input: String
    @Binding var isError: Bool
    @FocusState var isFieldFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $input)
                .padding(.leading, Spacing.large)
                .offset(y: 9)
                .body2Style()
                .focused($isFieldFocused)
                .lineLimit(1)
                .keyboardType(.asciiCapable)
                .frame(width: screenWidth - (Spacing.large * 2), height: 56)
                .overlay {
                    FieldOverlay(isError: $isError, isFocused: _isFieldFocused)
                }
            
            Text("Your name")
                .font(input.isEmpty && !isFieldFocused ? .p2 : .p3)
                .foregroundStyle(isError ? Color.errorColor : (isFieldFocused ? (input.isEmpty ? Color.secondaryColor : Color.enabledFilledFocussedColor) : Color.black_48))
                .padding(.leading, Spacing.large)
                .offset(y: input.isEmpty && !isFieldFocused ? 0 : -14)
                .onTapGesture {
                    withAnimation { isFieldFocused.toggle() }
                }
        }
        .animation(.linear(duration: 0.2), value: isFieldFocused)
        
    }
}

struct CustomUsernameTextField_Previews: PreviewProvider {
    @State static var input = ""
    @State static var isError = false
    @State static var isFilledInput = "Username"
    @FocusState static var isFieldFocused: Bool
    
    static var previews: some View {
        Group {
            CustomUsernameTextField(input: $input, isError: $isError)
                .focused($isFieldFocused)
                .previewDisplayName("Enabled")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomUsernameTextField(input: $input, isError: .constant(true))
                .focused($isFieldFocused)
                .previewDisplayName("Enabled - Error")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomUsernameTextField(input: $isFilledInput, isError: $isError)
                .focused($isFieldFocused)
                .previewDisplayName("Enabled - Filled")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomUsernameTextField(input: $isFilledInput, isError: .constant(true))
                .focused($isFieldFocused)
                .previewDisplayName("Enabled - Filled - Error")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
