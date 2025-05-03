//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import SwiftUI

@main
struct TestTaskApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
