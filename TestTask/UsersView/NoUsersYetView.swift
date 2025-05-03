//
//  NoUsersYetView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import SwiftUI

struct NoUsersYetView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.primary
                Text("Working with GET request")
                    .headingStyle()
                    .foregroundColor(.black.opacity(0.87))
                    .padding(.vertical, Spacing.large)
            }
            .frame(height: 56)
            
            Spacer()
            
            VStack(spacing: 24) {
                Image("noUsers")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 201, height: 200)
                
                Text("There are no users yet")
                    .headingStyle()
            }
            
            Spacer()
        }
    }
}

#Preview {
    NoUsersYetView()
}
