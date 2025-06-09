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
                    Image("photoCover")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(.gray.opacity(0.5))
                        )
                }
                
                VStack(alignment: .leading, spacing: Spacing.medium) {
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text(user.name)
                            .body2Style()
                            .foregroundStyle(Color.black_87)
                        
                        Text(user.position)
                            .body3Style()
                            .foregroundStyle(Color.black_60)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text(user.email)
                            .body3Style()
                            .foregroundStyle(Color.black_87)
                            .lineLimit(1)
                        
                        Text(user.phone.formattedPhoneNumber())
                            .body3Style()
                            .foregroundStyle(Color.black_87)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, Spacing.large)
            .padding(.horizontal, Spacing.large)
            
            Divider()
                .padding(.leading, 82)
                .padding(.trailing, 16)
        }
        .background(Color.backgroundColor)
    }
}

struct UsersListItem_Previews: PreviewProvider {
    static var previews: some View {
        UsersListItem(user: User(
            id: 2,
            name: "Gayle Weimann",
            email: "gayle.weimann@gmail.com",
            phone: "+38 (098) 777 88 55",
            position: "Backend developer",
            positionID: 2,
            registrationTimestamp: 1609459200,
            photo: "https://randomuser.me/api/portraits/women/44.jpg"
        ))
        .previewLayout(.sizeThatFits)
    }
}
