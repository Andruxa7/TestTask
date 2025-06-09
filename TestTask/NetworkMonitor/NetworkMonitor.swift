//
//  NetworkMonitor.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    func testNetworkConnection() async {
        do {
            let url = URL(string: "https://www.google.com")!
            let (_, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                await MainActor.run {
                    self.isConnected = true
                    self.objectWillChange.send()
                }
            }
        } catch {
            await MainActor.run {
                self.isConnected = false
                self.objectWillChange.send()
            }
        }
    }
}
