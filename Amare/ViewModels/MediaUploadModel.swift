//
//  MediaUploadModel.swift
//  Amare
//
//  Created by Micheal Bingham on 11/15/23.
//

import Foundation
import PhotosUI
import CoreTransferable
import SwiftUI




class MediaUploadModel: ObservableObject {
    
    // MARK: - Profile Image
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        let data: Data
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
            
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image, data: data)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
   
    
    @Published var urlToProfileImage: String = ""
    
    @Published var error: Error? {
        didSet{
            errorDidHappen = error != nil
        }
    }
    @Published var errorDidHappen: Bool = false
    
    
    @Published private(set) var imageState: ImageState = .empty

    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async { [self] in
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                    upload(imageData: profileImage.data)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    private func upload(imageData: Data?) {
            #if canImport(UIKit)
        
        if let data = imageData {
                // Now you have the image data for iOS
                // Continue with your Firebase upload..
                FirestoreService.shared.uploadImageToFirebaseStorage(imageData: data) { result in
                    
                    switch result {
                    case .success(let success):
                        self.urlToProfileImage = success.absoluteString
                    case .failure(let failure):
                        print("could not upload image due to .. \(failure)")
                        self.error = failure
                    }
                }
                
            }
            #elseif canImport(AppKit)
            if let imageData = image.nsImage.toData() {
                // Now you have the image data for macOS
                // Continue with your Firebase upload...
                // No need for this because we're not making a macOS app
            }
            #endif
        }
    }

