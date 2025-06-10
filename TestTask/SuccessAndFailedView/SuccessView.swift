//
//  SuccessView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct SuccessView: View {
    @Binding var showSuccessView: Bool
    @EnvironmentObject var vm: SignUpViewModel
    let onGotItTapped: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image("successImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                
                Text("User successfully registered")
                    .headingStyle()
                    .foregroundStyle(Color.black_87)
                
                Button {
                    vm.clearForm()
                    onGotItTapped()
                    showSuccessView = false
                } label: {
                    Text("Got it")
                }
                .buttonStyle(CustomButtonStyle(type: .primary))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        vm.clearForm()
                        showSuccessView = false
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
    SuccessView(showSuccessView: .constant(true), onGotItTapped: {
        print(">>> Got it!")
    })
    .environmentObject(SignUpViewModel())
}
