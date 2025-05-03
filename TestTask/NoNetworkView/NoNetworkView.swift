//
//  NoNetworkView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image("noInternetConnection")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("There is no internet connection")
                .headingStyle()
            
            Button {
                // retry boot
            } label: {
                Text("Try again")
            }
            .buttonStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    NoNetworkView()
}
