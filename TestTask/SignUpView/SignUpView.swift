//
//  SignUpView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.primary
                Text("Working with POST request")
                    .headingStyle()
                    .foregroundColor(.black.opacity(0.87))
                    .padding(.vertical, Spacing.large)
            }
            .frame(height: 56)
            
            Spacer()
            
            Text("SignUpView")
                .headingStyle()
            
            Spacer()
        }
        .background(Color.background1)
    }
}

#Preview {
    SignUpView()
}
