//
//  CustomEmailTextField.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct CustomEmailTextField: View {
    @Binding var input: String
    @Binding var isError: Bool
    @FocusState var isFieldFocused
    
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
            
            Text("Email")
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

struct CustomEmailTextField_Previews: PreviewProvider {
    @State static var input = ""
    @State static var isError = false
    
    static var previews: some View {
        Group {
            CustomEmailTextField(input: $input, isError: $isError)
                .previewDisplayName("Normal State")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomEmailTextField(input: .constant(""), isError: .constant(true))
                .previewDisplayName("Error State")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
