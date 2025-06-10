//
//  SignUpViewModel.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import Foundation
import SwiftUI
import UIKit

class SignUpViewModel: ObservableObject {
    
    // Form fields
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var photoIsUploaded: String = ""
    @Published var photoData: Data? = nil
    
    // Positions
    @Published var positions: [Position] = []
    @Published var selectedPosition: Position?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Error states
    @Published var isUsernameError = false
    @Published var isEmailError = false
    @Published var isPhoneError = false
    @Published var isPhotoUploadedError = false
    
    // Error messages
    @Published var usernameErrorText = "Username should contain 2-60 characters"
    @Published var emailErrorText = "Invalid email format"
    @Published var phoneErrorText = "Phone number must be 9 digits"
    @Published var photoErrorText = "Photo is required"
    
    @Published var serverError: String?
    
    private var token: SaveToken?
    private var userService: UsersService = UsersService()
    
    // Validation constants
    let usernameMinLength = 2
    let usernameMaxLength = 60
    let emailMinLength = 6
    let emailMaxLength = 100
    let photoMinDimension = 70
    let photoMaxFileSize = 5 * 1024 * 1024
    
    var canEnableSignUpButton: Bool {
        !username.isEmpty || !email.isEmpty || !phone.isEmpty || !photoIsUploaded.isEmpty
    }
    
    func validateForm() -> Bool {
        var isValid = true
        
        // Validate username
        if username.isEmpty || username.count < usernameMinLength || username.count > usernameMaxLength {
            isUsernameError = true
            usernameErrorText = username.isEmpty ? "Required field" : "Username should contain 2-60 characters"
            isValid = false
        } else {
            isUsernameError = false
        }
        
        // Validate email
        if !isValidEmail(email) {
            isEmailError = true
            emailErrorText = email.isEmpty ? "Required field" : "Invalid email format"
            isValid = false
        } else if email.count < emailMinLength || email.count > emailMaxLength {
            isEmailError = true
            emailErrorText = "Email should be between 6-100 characters"
            isValid = false
        } else {
            isEmailError = false
        }
        
        // Validate phone
        if phone.count != 9 {
            isPhoneError = true
            phoneErrorText = phone.isEmpty ? "Required field" : "Phone number must be 9 digits"
            isValid = false
        } else {
            isPhoneError = false
        }
        
        // Validate photo
        if photoIsUploaded.isEmpty {
            isPhotoUploadedError = true
            photoErrorText = "Photo is required"
            isValid = false
        } else if !validatePhoto() {
            isPhotoUploadedError = true
            isValid = false
        } else {
            isPhotoUploadedError = false
        }
        
        // Validate position
        if selectedPosition == nil {
            isValid = false
        }
        
        return isValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        
        let emailRegEx = "^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePhoto() -> Bool {
        guard let photoData = self.photoData else {
            photoErrorText = "Photo data is missing"
            return false
        }
        
        if photoData.count > photoMaxFileSize {
            photoErrorText = "Photo size should not exceed 5 MB"
            return false
        }
        
        guard let image = UIImage(data: photoData) else {
            photoErrorText = "Invalid image format"
            return false
        }
        
        if image.size.width < CGFloat(photoMinDimension) || image.size.height < CGFloat(photoMinDimension) {
            photoErrorText = "Photo dimensions should be at least 70x70 px"
            return false
        }
        
        let header = photoData.prefix(3)
        if header.count >= 3 {
            let isJpeg = header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF
            if !isJpeg {
                photoErrorText = "Photo must be in JPEG/JPG format"
                return false
            }
        }
        
        return true
    }
    
    func processPhotoData(from image: UIImage) {
        let targetSize = CGSize(width: 1024, height: 1024)
        let resizedImage = image.resized(to: targetSize) ?? image
        
        guard let jpegData = resizedImage.jpegData(compressionQuality: 0.8) else {
            photoIsUploaded = ""
            photoErrorText = "Failed to process photo data"
            isPhotoUploadedError = true
            return
        }
        
        self.photoData = jpegData
        photoIsUploaded = jpegData.base64EncodedString()
        
        if !validatePhoto() {
            isPhotoUploadedError = true
        } else {
            isPhotoUploadedError = false
        }
    }
    
    @MainActor
    func signUp() async -> Bool {
        guard validateForm() else {
            return false
        }
        
        let formattedPhone = "+380" + phone
        
        if let t = self.token {
            let timeInterval = Date().timeIntervalSince(t.time)
            let isTokenValid = timeInterval < 40 * 60
            
            if !isTokenValid {
                let success = await getToken()
                guard success else { return false }
            }
        } else {
            let success = await getToken()
            guard success else { return false }
        }
        
        guard let token = self.token?.token else {
            self.serverError = "Token is missing"
            return false
        }
        
        do {
            let success = try await userService.performSignUp(
                token: token,
                username: username,
                email: email,
                phone: formattedPhone,
                positionId: selectedPosition?.id ?? 1,
                photoData: photoData
            )
            return success
        } catch let error as NetworkError {
            switch error {
            case .validationError(let message, let fails):
                var errorMessage = message
                let failureDetails = fails.map { "\($0.key): \($0.value.joined(separator: ", "))" }.joined(separator: "; ")
                if !failureDetails.isEmpty {
                    errorMessage += " (\(failureDetails))"
                }
                self.serverError = errorMessage
            case .httpStatus(let statusCode):
                switch statusCode {
                case 409:
                    self.serverError = "User with this phone or email already exists"
                case 401:
                    self.serverError = "The token expired"
                default:
                    self.serverError = "Sign up failed with status code \(statusCode)"
                }
            case .serverError(let underlyingError):
                self.serverError = "Server error occurred\(underlyingError != nil ? ": \(underlyingError!.localizedDescription)" : "")"
            case .decodingError(let decodingError):
                self.serverError = "Failed to parse response: \(decodingError.localizedDescription)"
            case .emptyResponse, .responseError, .notFound, .invalidURL:
                self.serverError = "Sign up failed: \(error.localizedDescription)"
            }
            return false
        } catch {
            self.serverError = "Sign up failed: \(error.localizedDescription)"
            return false
        }
    }
    
    @MainActor
    func clearForm() {
        username = ""
        email = ""
        phone = ""
        photoData = nil
        photoIsUploaded = ""
        selectedPosition = positions.first
    }
    
    @MainActor
    func getToken(maxRetries: Int = 3, retryDelay: TimeInterval = 1.0) async -> Bool {
        for attempt in 1...maxRetries {
            do {
                let newToken = try await userService.fetchToken()
                self.token = SaveToken(token: newToken)
                print("Token is: \(String(describing: self.token))")
                self.serverError = nil
                return true
            } catch NetworkError.serverError(_) {
                self.serverError = "This functionality is temporarily unavailable. Server error. \(attempt < maxRetries ? "Retrying..." : "Please try again later.")"
                if attempt < maxRetries {
                    try? await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                    continue
                }
                return false
            } catch {
                self.serverError = "Failed to fetch token: \(error.localizedDescription)"
                return false
            }
        }
        return false
    }
    
    @MainActor
    func fetchPositions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.positions = try await userService.loadPositionsData()
            if !self.positions.isEmpty {
                self.selectedPosition = self.positions.first
            }
        } catch {
            self.errorMessage = "Failed to load positions: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
}
