//
//  ContentView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        NavigationView {
            Group {
                if networkMonitor.isConnected {
                    NoUsersYetView()
                } else {
                    NoNetworkView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NetworkMonitor())
}
