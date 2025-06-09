//
//  ErrorView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(Color.errorColor)
            
            Text("Something went wrong")
                .headingStyle()
                .foregroundStyle(Color.errorColor)
            
            Text(message)
                .body1Style()
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.black_87)
                .padding(.horizontal)
            
            Button(action: retryAction) {
                Text("Try Again")
            }
            .buttonStyle(CustomButtonStyle(type: .primary))
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundColor)
                .shadow(color: .black_87.opacity(0.15), radius: 10)
        )
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Unable to load data. \nPlease try again.") {
            print("Retry tapped")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
