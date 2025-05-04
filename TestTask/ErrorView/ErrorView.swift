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
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
        )
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Unable to load data. Please try again.") {
            print("Retry tapped")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
