//
//  NoNetworkView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import SwiftUI

struct NoNetworkView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var isRetrying = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image("noInternetConnection")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
            
            if isRetrying {
                ProgressView()
                    .frame(width: 27, height: 27)
                    .scaleEffect(1.4)
            } else {
                Text("There is no internet connection")
                    .headingStyle()
                    .foregroundStyle(Color.black_87)
            }
            
            Button {
                Task {
                    isRetrying = true
                    await networkMonitor.testNetworkConnection()
                    
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
        .background(Color.backgroundColor)
    }
}

#Preview {
    NoNetworkView()
        .environmentObject(NetworkMonitor())
}
