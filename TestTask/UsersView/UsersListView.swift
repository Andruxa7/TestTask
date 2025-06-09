//
//  UsersListView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import SwiftUI

struct UsersListView: View {
    
    @EnvironmentObject var viewModel: UserViewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.primaryColor
                Text("Working with GET request")
                    .headingStyle()
                    .foregroundStyle(Color.topbarTextColor)
            }
            .frame(height: 56)
            
            if viewModel.hasError {
                Spacer()
                ErrorView(message: viewModel.errorMessage) {
                    Task {
                        await viewModel.loadUsers()
                    }
                }
                Spacer()
            } else if viewModel.users.isEmpty && viewModel.isLoading {
                NoUsersYetView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.users) { user in
                            UsersListItem(user: user)
                                .task {
                                    await viewModel.loadNextPageIfNeeded(currentUser: user)
                                }
                        }
                        
                        if viewModel.isLoading && !viewModel.users.isEmpty {
                            ProgressView()
                                .scaleEffect(0.8)
                                .padding()
                        }
                    }
                    .padding(.bottom, 70)
                }
                .refreshable {
                    Task {
                        await viewModel.loadUsers(isRefresh: true)
                    }
                }
            }
        }
        .task {
            if viewModel.users.isEmpty {
                await viewModel.loadUsers()
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserViewViewModel()
        viewModel.users = [
            User(id: 1,
                 name: "Malcolm Bailey",
                 email: "jany_murazik51@hotmail.com",
                 phone: "+38 (098) 278 76 24",
                 position: "Frontend developer",
                 positionID: 1,
                 registrationTimestamp: 1609459200,
                 photo: "https://randomuser.me/api/portraits/men/32.jpg"),
            User(id: 2,
                 name: "Seraphina Anastasia Isolde Aurelia Celestina von Hohenzollern",
                 email: "maximus_wilderman_ronaldo_schuppe",
                 phone: "+38 (098) 278 76 24",
                 position: "Backend developer",
                 positionID: 2,
                 registrationTimestamp: 1609459200,
                 photo: "https://randomuser.me/api/portraits/women/44.jpg"),
            User(id: 3,
                 name: "Gayle Weimann",
                 email: "kenyatta.herman@hotmail.com",
                 phone: "+38 (098) 278 76 24",
                 position: "Designer",
                 positionID: 3,
                 registrationTimestamp: 1609459200,
                 photo: "https://randomuser.me/api/portraits/men/46.jpg")
        ]
        
        return UsersListView()
            .environmentObject(UserViewViewModel())
    }
}
