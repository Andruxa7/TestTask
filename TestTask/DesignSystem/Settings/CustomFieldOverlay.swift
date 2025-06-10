//
//  CustomFieldOverlay.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import Foundation
import SwiftUI

struct FieldOverlay: View {
    @Binding var isError: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(isError ? Color.errorColor : (isFocused ? Color.secondaryColor : Color.borderColor), lineWidth: 1)
    }
}
