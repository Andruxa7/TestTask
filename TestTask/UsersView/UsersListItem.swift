//
//  UsersListItem.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import SwiftUI

struct UsersListItem: View {
    var user: User
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: Spacing.large) {
                AsyncImage(url: URL(string: user.photo)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(.gray.opacity(0.5))
                        )
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(.gray.opacity(0.5))
                        )
                }
                
                VStack(alignment: .leading, spacing: Spacing.small) {
                    Text(user.name)
                        .body2Style()
                        .foregroundColor(.black.opacity(0.87))
                    
                    Text(user.position)
                        .body3Style()
                        .foregroundColor(.black.opacity(0.60))
                        .padding(.bottom, Spacing.small)
                    
                    Text(user.email)
                        .body3Style()
                        .foregroundColor(.black.opacity(0.87))
                        .lineLimit(1)
                        .padding(.bottom, Spacing.small)
                    
                    Text(user.phone)
                        .body3Style()
                        .foregroundColor(.black.opacity(0.87))
                }
                
                Spacer()
            }
            .padding(.vertical, Spacing.large)
            .padding(.horizontal, Spacing.large)
            
            Divider()
                .padding(.leading, 82)
                .padding(.trailing, 16)
        }
        .background(Color.white)
    }
}

// MARK: - Preview Provider
struct UsersListItem_Previews: PreviewProvider {
    static var previews: some View {
        UsersListItem(user: User(
            id: 2,
            name: "Seraphina Anastasia Isolde Aurelia Celestina von Hohenzollern",
            email: "maximus_wilderman_ronaldo_schuppe",
            phone: "+38 (098) 278 76 24",
            position: "Backend developer",
            positionID: 2,
            registrationTimestamp: 1609459200,
            photo: "https://randomuser.me/api/portraits/women/44.jpg"
        ))
        .previewLayout(.sizeThatFits)
    }
}
