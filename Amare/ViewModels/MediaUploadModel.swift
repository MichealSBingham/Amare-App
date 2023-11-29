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

class ExtraMediaUploadViewModel: ObservableObject {
    
    @Published var firstImageURL: String = ""
    @Published var secondImageURL: String = ""
    
    @Published var croppedProfileImage1: UIImage?
    @Published var originalProfileImage1: UIImage?
    
    @Published var croppedProfileImage2: UIImage?
    @Published var originalProfileImage2: UIImage?
    
    // Upload two sets of images
    func uploadExtraImages(completion: @escaping ((URL?, URL?, URL?, URL?, Error?) -> Void)) {
        let uploadGroup = DispatchGroup()

        var firstCroppedURL: URL?
        var firstOriginalURL: URL?
        var secondCroppedURL: URL?
        var secondOriginalURL: URL?
        var encounteredError: Error?

        // Upload first set of images
        if let cropImage1 = croppedProfileImage1, let orgImage1 = originalProfileImage1 {
            uploadGroup.enter()
            FirestoreService.shared.uploadProfileAndOriginalImagesToFirebaseStorage(croppedImage: cropImage1, originalImage: orgImage1, name: "1") { result in
                switch result {
                case .success(let (croppedURL, originalURL)):
                    firstCroppedURL = croppedURL
                    firstOriginalURL = originalURL
                case .failure(let error):
                    print("Error with the first image: \(error)")
                    encounteredError = error
                }
                uploadGroup.leave()
            }
        }

        // Upload second set of images
        if let cropImage2 = croppedProfileImage2, let orgImage2 = originalProfileImage2 {
            uploadGroup.enter()
            FirestoreService.shared.uploadProfileAndOriginalImagesToFirebaseStorage(croppedImage: cropImage2, originalImage: orgImage2, name: "2") { result in
                switch result {
                case .success(let (croppedURL, originalURL)):
                    secondCroppedURL = croppedURL
                    secondOriginalURL = originalURL
                case .failure(let error):
                    print("Error with the second image: \(error)")
                    encounteredError = error
                }
                uploadGroup.leave()
            }
        }

        // Handle completion
        uploadGroup.notify(queue: .main) {
            if let error = encounteredError {
                completion(nil, nil, nil, nil, error)
            } else {
                completion(firstCroppedURL, firstOriginalURL, secondCroppedURL, secondOriginalURL, nil)
            }
        }
    }

    
}


class MediaUploadModel: ObservableObject {
    
    
    
   
    
    @Published var urlToProfileImage: String = ""
    
    @Published var croppedProfileImage: UIImage?
    @Published var originalProfileImage: UIImage? 
    
    
 
    
    // MARK: -  Methods
    
    func uploadProfileImage(croppedImage: UIImage?, originalImage: UIImage?, completion: @escaping ((URL?, URL?, Error?) -> Void)){
        guard let croppedImage = croppedImage, let originalImage = originalImage else {
            return
        }
        FirestoreService.shared.uploadProfileAndOriginalImagesToFirebaseStorage(croppedImage: croppedImage, originalImage: originalImage) { result in
            
            switch result {
                case .success(let (croppedURL, originalURL)):
                    print("Cropped Image URL: \(croppedURL)")
                    print("Original Image URL: \(originalURL)")
                completion(croppedURL, originalURL, nil)
                case .failure(let error):
                    print("Error uploading images: \(error)")
           
                completion(nil, nil, error)
                }
        }
    }
    
    }

