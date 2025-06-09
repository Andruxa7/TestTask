//
//  SplashScreenView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack {
                Image("logoTestTask")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 106.46)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
