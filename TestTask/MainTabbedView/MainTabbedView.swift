//
//  MainTabbedView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import SwiftUI

enum TabbedItems: Int, CaseIterable {
    case users = 0
    case signUp
    
    var title: String {
        switch self {
        case .users:
            return "Users"
        case .signUp:
            return "Sign up"
        }
    }
    
    var iconName: String {
        switch self {
        case .users:
            return "personSequenceFill"
        case .signUp:
            return "personBadgePlus"
        }
    }
}

struct MainTabbedView: View {
    @State var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                UsersListView()
                    .tag(0)
                
                SignUpView()
                    .tag(1)
            }
            
            HStack(spacing: 0) {
                Spacer()
                Button {
                    selectedTab = TabbedItems.users.rawValue
                } label: {
                    HStack(spacing: Spacing.medium) {
                        Image(TabbedItems.users.iconName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .frame(width: 40, height: 17)
                            .foregroundColor(selectedTab == TabbedItems.users.rawValue ? Color.secondaryColor : Color.black_60)
                        
                        Text(TabbedItems.users.title)
                            .body1Style()
                            .foregroundColor(selectedTab == TabbedItems.users.rawValue ? Color.secondaryColor : Color.black_60)
                    }
                }
                Spacer()
                Button {
                    selectedTab = TabbedItems.signUp.rawValue
                } label: {
                    HStack(spacing: Spacing.medium) {
                        Image(TabbedItems.signUp.iconName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .frame(width: 22, height: 17)
                            .foregroundColor(selectedTab == TabbedItems.signUp.rawValue ? Color.secondaryColor : Color.black_60)
                        
                        Text(TabbedItems.signUp.title)
                            .body1Style()
                            .foregroundColor(selectedTab == TabbedItems.signUp.rawValue ? Color.secondaryColor : Color.black_60)
                    }
                }
                Spacer()
            }
            .padding(.top, Spacing.large)
            .padding(.bottom, Spacing.small)
        }
    }
}

#Preview {
    MainTabbedView()
}
