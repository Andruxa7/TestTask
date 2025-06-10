//
//  CustomPhoneTextField.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct CustomPhoneTextField: View {
    @Binding var input: String
    @Binding var isError: Bool
    @FocusState private var isFieldFocused: Bool
    @State private var displayedText: String = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $displayedText)
                .padding(.leading, Spacing.large)
                .offset(y: 9)
                .body2Style()
                .focused($isFieldFocused)
                .lineLimit(1)
                .keyboardType(.numberPad)
                .frame(width: screenWidth - (Spacing.large * 2), height: 56)
                .onChange(of: displayedText) { _, newValue in
                    processInput(newValue)
                }
                .overlay {
                    FieldOverlay(isError: $isError, isFocused: _isFieldFocused)
                }
            
            Text("Phone")
                .font(input.isEmpty && !isFieldFocused ? .p2 : .p3)
                .foregroundStyle(isError ? Color.errorColor : (isFieldFocused ? (input.isEmpty ? Color.secondaryColor : Color.enabledFilledFocussedColor) : Color.black_48))
                .padding(.leading, Spacing.large)
                .offset(y: input.isEmpty && !isFieldFocused ? 0 : -14)
                .onTapGesture {
                    withAnimation { isFieldFocused = true }
                }
        }
        .animation(.linear(duration: 0.2), value: isFieldFocused)
        .onAppear {
            if !input.isEmpty {
                displayedText = formatPhoneNumber(input)
            } else {
                displayedText = ""
            }
        }
        .onChange(of: input) { _, newValue in
            if !newValue.isEmpty {
                displayedText = formatPhoneNumber(newValue)
            } else if !isFieldFocused {
                displayedText = ""
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: isFieldFocused) { _, newValue in
            handleFocusChange(newValue)
        }
    }
    
    private func handleFocusChange(_ focused: Bool) {
        if focused {
            if input.isEmpty {
                displayedText = "+38 (0"
            } else {
                displayedText = formatPhoneNumber(input)
            }
            
            NotificationCenter.default.post(
                name: NSNotification.Name("KeyboardWillShow"),
                object: nil
            )
        } else {
            if input.isEmpty {
                displayedText = ""
            } else {
                displayedText = formatPhoneNumber(input)
            }
            
            NotificationCenter.default.post(
                name: NSNotification.Name("KeyboardWillHide"),
                object: nil
            )
        }
    }
    
    private func processInput(_ newValue: String) {
        if !newValue.hasPrefix("+38 (0") && !input.isEmpty {
            displayedText = "+38 (0" + getDigitsOnly(from: newValue).prefix(9)
            return
        }
        
        let inputDigits = getDigitsOnly(from: newValue)
        
        if inputDigits.count > 9 {
            input = String(inputDigits.prefix(9))
            displayedText = formatPhoneNumber(input)
        } else {
            input = inputDigits
            isError = false
        }
    }
    
    private func getDigitsOnly(from text: String) -> String {
        var processedText = text
        if processedText.hasPrefix("+38 (0") {
            processedText = String(processedText.dropFirst(6))
        }
        
        return processedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    private func formatPhoneNumber(_ value: String) -> String {
        let digits = value
        
        var formatted = "+38 (0"
        
        for (index, digit) in digits.enumerated() {
            switch index {
            case 0...1:
                formatted.append(digit)
                if index == 1 { formatted.append(") ") }
            case 2...4:
                formatted.append(digit)
                if index == 4 { formatted.append(" ") }
            case 5...6:
                formatted.append(digit)
                if index == 6 { formatted.append(" ") }
            case 7...8:
                formatted.append(digit)
            default:
                break
            }
        }
        
        return formatted
    }
}

struct CustomPhoneTextField_Previews: PreviewProvider {
    @State static var input = ""
    @State static var isError = false
    
    static var previews: some View {
        Group {
            CustomPhoneTextField(input: $input, isError: $isError)
                .previewDisplayName("Normal State")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomPhoneTextField(input: .constant(""), isError: .constant(true))
                .previewDisplayName("Error State")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
