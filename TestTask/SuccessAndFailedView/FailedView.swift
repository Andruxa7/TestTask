//
//  FailedView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct FailedView: View {
    @Binding var showFailedView: Bool
    @State private var isRetrying = false
    
    let message: String
    let retryAction: () async -> Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image("failedImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                
                if isRetrying {
                    ProgressView()
                        .frame(width: 27, height: 27)
                        .scaleEffect(1.4)
                } else {
                    Text(message)
                        .headingStyle()
                        .foregroundStyle(Color.black_87)
                }
                
                Button {
                    Task {
                        isRetrying = true
                        
                        let success = await retryAction()
                        if success {
                            showFailedView = false
                        }
                        
                        print("Try again is tapped!!!")
                        
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        isRetrying = false
                    }
                } label: {
                    Text(isRetrying ? "Checking..." : "Try again")
                }
                .buttonStyle(CustomButtonStyle(type: .primary))
                .disabled(isRetrying)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showFailedView = false
                    } label: {
                        Image("closeButton")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 29)
                            .padding(.top, 29)
                    }
                }
                Spacer()
            }
        }
        .background(Color.backgroundColor)
        
    }
}

#Preview {
    let vm = SignUpViewModel()
    FailedView(showFailedView: .constant(true), message: "That email is already registered", retryAction: {
        await vm.signUp()
    })
}
