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
            Spacer()
            
            VStack(spacing: 24) {
                Image("noUsers")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 201, height: 200)
                
                Text("There are no users yet")
                    .headingStyle()
                    .foregroundStyle(Color.black_87)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NoUsersYetView()
}
