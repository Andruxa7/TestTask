//
//  SignUpView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 04.05.2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var vm = SignUpViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        Color.primaryColor
                        Text("Working with POST request")
                            .headingStyle()
                            .foregroundStyle(Color.topbarTextColor)
                    }
                    .frame(height: 56)
                    
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: Spacing.small) {
                            CustomUsernameTextField(input: $vm.username, isError: $vm.isUsernameError)
                                .onChange(of: vm.username) { _, newValue in
                                    if newValue.count >= vm.usernameMinLength && newValue.count <= vm.usernameMaxLength {
                                        vm.isUsernameError = false
                                    }
                                }
                                .onSubmit {
                                    if vm.username.isEmpty || vm.username.count < vm.usernameMinLength || vm.username.count > vm.usernameMaxLength {
                                        vm.isUsernameError = true
                                        vm.usernameErrorText = vm.username.isEmpty ? "Required field" : "Username should contain 2-60 characters"
                                    } else {
                                        vm.isUsernameError = false
                                    }
                                }
                            
                            if vm.isUsernameError {
                                Text(vm.usernameErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.errorColor)
                                    .padding(.horizontal, Spacing.large)
                            } else {
                                Text(vm.usernameErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.clear)
                                    .padding(.horizontal, Spacing.large)
                            }
                        }
                        .padding(.top, 32)
                        
                        VStack(alignment: .leading, spacing: Spacing.small) {
                            CustomEmailTextField(input: $vm.email, isError: $vm.isEmailError)
                                .onChange(of: vm.email) { _, newValue in
                                    if !newValue.isEmpty && vm.isValidEmail(newValue) && newValue.count >= vm.emailMinLength && newValue.count <= vm.emailMaxLength {
                                        vm.isEmailError = false
                                    }
                                }
                                .onSubmit {
                                    if !vm.isValidEmail(vm.email) {
                                        vm.isEmailError = true
                                        vm.emailErrorText = vm.email.isEmpty ? "Required field" : "Invalid email format"
                                    } else if vm.email.count < vm.emailMinLength || vm.email.count > vm.emailMaxLength {
                                        vm.isEmailError = true
                                        vm.emailErrorText = "Email should be between 6-100 characters"
                                    } else {
                                        vm.isEmailError = false
                                    }
                                }
                            
                            if vm.isEmailError {
                                Text(vm.emailErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.errorColor)
                                    .padding(.horizontal, Spacing.large)
                            } else {
                                Text(vm.emailErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.clear)
                                    .padding(.horizontal, Spacing.large)
                            }
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: Spacing.small) {
                            CustomPhoneTextField(input: $vm.phone, isError: $vm.isPhoneError)
                                .onChange(of: vm.phone) { _, newValue in
                                    if newValue.count == 9 {
                                        vm.isPhoneError = false
                                    }
                                }
                                .onSubmit {
                                    if vm.phone.count != 9 {
                                        vm.isPhoneError = true
                                        vm.phoneErrorText = vm.phone.isEmpty ? "Required field" : "Phone number must be 9 digits"
                                    } else {
                                        vm.isPhoneError = false
                                    }
                                }
                            
                            if vm.isPhoneError {
                                Text(vm.phoneErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.errorColor)
                                    .padding(.horizontal, Spacing.large)
                            } else {
                                Text("+38 (XXX) XXX XX XX")
                                    .body3Style()
                                    .foregroundStyle(Color.black_60)
                                    .padding(.horizontal, Spacing.large)
                            }
                        }
                        .padding(.top, 10)
                        
                        VStack {
                            PositionSelectionView(vm: vm)
                        }
                        .padding(.top, 24)
                        
                        VStack(alignment: .leading, spacing: Spacing.small) {
                            CustomUploadPhotoField(
                                isError: $vm.isPhotoUploadedError,
                                isPhotoUploaded: .init(get: { !vm.photoIsUploaded.isEmpty }, set: { _ in })
                            ) { image in
                                if let image = image {
                                    vm.processPhotoData(from: image)
                                }
                                
                                if vm.photoIsUploaded.isEmpty {
                                    vm.isPhotoUploadedError = true
                                    vm.photoErrorText = "Photo is required"
                                } else if !vm.validatePhoto() {
                                    vm.isPhotoUploadedError = true
                                } else {
                                    vm.isPhotoUploadedError = false
                                }
                            }
                            
                            if vm.isPhotoUploadedError {
                                Text(vm.photoErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.errorColor)
                                    .padding(.horizontal, Spacing.large)
                            } else {
                                Text(vm.photoErrorText)
                                    .body3Style()
                                    .foregroundStyle(Color.clear)
                                    .padding(.horizontal, Spacing.large)
                            }
                        }
                        .padding(.top, 24)
                        
                        Button {
                            Task {
                                vm.serverError = nil
                                let isValid = vm.validateForm()
                                if isValid {
                                    let success = await vm.signUp()
                                    if success {
                                        print("Signup successful")
                                    } else {
                                        print("Signup failed")
                                    }
                                }
                            }
                        } label: {
                            Text("Sign up")
                        }
                        .disabled(!vm.canEnableSignUpButton || vm.isLoading)
                        .buttonStyle(CustomButtonStyle(type: .primary, isEnabled: vm.canEnableSignUpButton && !vm.isLoading))
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, Spacing.large)
                }
            }
            .background(Color.backgroundColor)
            .onAppear {
                Task {
                    await vm.fetchPositions()
                }
            }
        }
        .environmentObject(vm)
        
    }
}

#Preview {
    SignUpView()
}
