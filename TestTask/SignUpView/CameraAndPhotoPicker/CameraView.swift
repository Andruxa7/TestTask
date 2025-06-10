//
//  CameraView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI
import UIKit
import PhotosUI

class NavigationHelper: ObservableObject {
    @Published var isPresented: Bool = false
    
    func dismiss() {
        isPresented = false
    }
    
    func present() {
        isPresented = true
    }
    
    func toggle() {
        isPresented.toggle()
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @EnvironmentObject var navigationHelper: NavigationHelper
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            parent.navigationHelper.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.navigationHelper.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera is not available on this device")
            navigationHelper.dismiss()
            return picker
        }
        
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.cameraCaptureMode = .photo
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
