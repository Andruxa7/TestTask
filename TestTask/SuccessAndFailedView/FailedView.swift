//
//  FailedView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct FailedView: View {
    @Binding var showFailedView: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image("failedImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                
                Text("That email is already registered")
                    .headingStyle()
                    .foregroundStyle(Color.black_87)
                
                Button {
                    print("Try again is tapped!!!")
                } label: {
                    Text("Try again")
                }
                .buttonStyle(CustomButtonStyle(type: .primary))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showFailedView = false
                    } label: {
                        Image("closeButton")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 29)
                            .padding(.top, 29)
                    }
                }
                Spacer()
            }
        }
        .background(Color.backgroundColor)

    }
}

#Preview {
    FailedView(showFailedView: .constant(true))
}
