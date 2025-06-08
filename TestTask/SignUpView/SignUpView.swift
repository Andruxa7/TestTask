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
                Color.primaryColor
                Text("Working with POST request")
                    .headingStyle()
                    .foregroundStyle(Color.topbarTextColor)
            }
            .frame(height: 56)
            
            Spacer()
            
            Text("SignUpView")
                .headingStyle()
            
            Spacer()
        }
        .background(Color.backgroundColor)
    }
}

#Preview {
    SignUpView()
}
