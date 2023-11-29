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

