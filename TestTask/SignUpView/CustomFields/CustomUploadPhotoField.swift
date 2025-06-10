//
//  CustomUploadPhotoField.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI
import UIKit
import PhotosUI
import AVFoundation

enum ImageSourceType {
    case camera
    case gallery
}

struct CustomUploadPhotoField: View {
    @Binding var isError: Bool
    @Binding var isPhotoUploaded: Bool
    @State private var showActionSheet = false
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var imageSourceType: ImageSourceType = .camera
    @State private var showCameraUnavailableAlert = false
    @StateObject private var navigationHelper = NavigationHelper()
    
    let onImageSelected: (UIImage?) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(isPhotoUploaded ? "Photo Uploaded" : "Upload your photo")
                        .foregroundStyle(isError ? Color.errorColor : (isPhotoUploaded ? Color.black_87 : Color.black_48))
                        .frame(height: 24)
                        .padding(.leading, Spacing.large)
                    
                    Spacer()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showActionSheet = true
                    }) {
                        Text("Upload")
                    }
                    .buttonStyle(CustomButtonStyle(type: .secondary))
                    .frame(height: 40)
                    .padding(.trailing, Spacing.medium)
                }
            }
        }
        .frame(width: screenWidth - (Spacing.large * 2), height: 56)
        .overlay {
            FieldOverlay(isError: $isError)
        }
        .confirmationDialog("Upload photo actions", isPresented: $showActionSheet) {
            Button("Camera") {
                imageSourceType = .camera
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                switch status {
                case .authorized:
                    showImagePicker = true
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.async {
                            if granted {
                                showImagePicker = true
                            } else {
                                showCameraUnavailableAlert = true
                            }
                        }
                    }
                case .denied, .restricted:
                    showCameraUnavailableAlert = true
                @unknown default:
                    showCameraUnavailableAlert = true
                }
            }
            
            Button("Gallery") {
                imageSourceType = .gallery
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {
                print("Cancel action")
            }
        } message: {
            Text("Choose how you want to add a photo")
        }
        .sheet(isPresented: $showImagePicker) {
            switch imageSourceType {
            case .camera:
                CameraView(image: $selectedImage)
                    .environmentObject(navigationHelper)
            case .gallery:
                PhotoPicker(selectedImage: $selectedImage)
            }
        }
        .onChange(of: selectedImage) { _, newImage in
            if let image = newImage {
                onImageSelected(image)
                isPhotoUploaded = true
                selectedImage = nil
            }
        }
        .alert("Camera Unavailable", isPresented: $showCameraUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The camera is not available on this device.")
        }
    }
    
    init(isError: Binding<Bool>, isPhotoUploaded: Binding<Bool>, onImageSelected: @escaping (UIImage?) -> Void) {
        self._isError = isError
        self._isPhotoUploaded = isPhotoUploaded
        self.onImageSelected = onImageSelected
    }
}

struct CustomUploadPhotoTextField_Previews: PreviewProvider {
    @State static var isError = false
    @State static var isPhotoUploaded = false
    
    static var previews: some View {
        Group {
            CustomUploadPhotoField(isError: $isError, isPhotoUploaded: $isPhotoUploaded) { _ in }
                .previewDisplayName("Normal State")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomUploadPhotoField(isError: .constant(true), isPhotoUploaded: $isPhotoUploaded) { _ in }
                .previewDisplayName("Error State")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CustomUploadPhotoField(isError: .constant(false), isPhotoUploaded: .constant(true)) { _ in }
                .previewDisplayName("Uploaded State")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
