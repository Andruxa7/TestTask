//
//  UserViewViewModel.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import Foundation
import SwiftUI

class UserViewViewModel: ObservableObject {
    
    @Published var users: [User] = []
        @Published var isLoading = false
        @Published var currentPage = 0
        @Published var totalPages = 0
        @Published var hasError = false
        @Published var errorMessage = ""
        private var userService: UsersService = UsersService()
    
    @MainActor
    func loadUsers(nextPage: Bool = false) async {
        isLoading = true
        hasError = false
        
        do {
            let pageToLoad = nextPage ? currentPage + 1 : 1
            let usersData = try await userService.loadUsersData(pageToLoad: pageToLoad)
            
            if nextPage {
                // Append users for pagination
                self.users.append(contentsOf: usersData.users)
            } else {
                // Replace users for initial load
                self.users = usersData.users
            }
            
            self.currentPage = usersData.page
            self.totalPages = usersData.totalPages
        } catch {
            print("Error loading users: \(error)")
            self.hasError = true
            self.errorMessage = "Failed to load users: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func loadNextPageIfNeeded(currentUser user: User) async {
        let thresholdIndex = self.users.index(self.users.endIndex, offsetBy: -2)
        if self.users.firstIndex(where: { $0.id == user.id }) ?? 0 >= thresholdIndex,
           currentPage < totalPages && !isLoading {
            await loadUsers(nextPage: true)
        }
    }
}
