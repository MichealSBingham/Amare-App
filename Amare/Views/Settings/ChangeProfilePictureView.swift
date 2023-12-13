//
//  ChangeProfilePictureView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/29/23.
//

import SwiftUI



struct ChangeProfilePictureView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: UserProfileModel
    
    @StateObject var viewModel: MediaUploadModel = MediaUploadModel()
    
    @State var showPicker: Bool = false
  
    @State var showLoadingIndicator: Bool = false
    
    @State var errorDidHappen: Bool = false
    @State var error: Error?
    
    
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
         
                Text("Upload a New Profile Picture")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .padding()
               
            
            
            HStack{
                
                                
                Button {
                    withAnimation{
                        showPicker.toggle()
                    }
                } label: {
                    if let image = viewModel.croppedProfileImage{
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                         
                    }
                    else {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }

                }
                .buttonStyle(.plain)
                .cropImagePicker(
                    options: [.circle, .square, .rectangle, .custom(.init(width: 350, height: 450))],
                    show: $showPicker,
                    originalImage: $viewModel.originalProfileImage,     // Binding to the original image
                    croppedImage: $viewModel.croppedProfileImage
                    
                )


                
                
                    
            }
            .padding()
            
            NextButtonView(text: showLoadingIndicator ? "Please Wait ... " :  "Done") {
                withAnimation {
                    beginImageUpload { error in
                        guard error == nil else {
                            return
                        }
                        dismissView()
                    }
                    
                }
            }
            
            .disabled((viewModel.croppedProfileImage == nil || showLoadingIndicator ) ? true: false )
            .opacity((viewModel.croppedProfileImage == nil || showLoadingIndicator) ? 0.5: 1 )
            
           
            
            Spacer()
            Spacer()
            
        }
        .alert(isPresented: $errorDidHappen, content: {
            Alert(
                title: Text("Something went wrong..."),
                message: Text("Please try again or another picture."),
                dismissButton: .default(Text("OK"), action: {
                    // Reset the variable when the alert's button is pressed
                    self.errorDidHappen = false
                })
            )
        })

        
       
    }
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func beginImageUpload(completion: @escaping  (Error?) -> Void ){
        withAnimation{
            showLoadingIndicator = true
        }
        
        if let cropImage = viewModel.croppedProfileImage, let orgImage = viewModel.originalProfileImage{
            
            // Upload the image
            viewModel.uploadProfileImage(croppedImage: cropImage, originalImage: orgImage) { croppedImageUrl, originalImageURl, error in
                
                print("===completion block : \(croppedImageUrl) and \(originalImageURl) and error is \(error)===")
                
                guard error == nil else {
                    print("===error is not nil=== ")
                    DispatchQueue.main.async {
                        self.error = error
                        errorDidHappen = true
                        showLoadingIndicator = false
                        viewModel.croppedProfileImage = nil
                        viewModel.originalProfileImage = nil
                        completion(error)
                    }
                     
                    return
                }
                
                let oldCroppedProfileImageURL = dataModel.user?.profileImageUrl ?? ""
                
                let oldFullProfileImageURL =  dataModel.user?.images[0] ?? ""
                
                let oldImages = dataModel.user?.images  ?? []
                
                let username = dataModel.user?.username ?? ""
                
                //Set the new image url
                DispatchQueue.main.async {
                    
                 
                    FirestoreService.shared.updateProfileImage(
                        croppedProfileImageURL: croppedImageUrl?.absoluteString ?? "",
                        fullProfileImageURL: originalImageURl?.absoluteString ?? "",
                        oldFullProfileImageURL: oldFullProfileImageURL,
                        imagesArray: oldImages,
                        username: username,
                        completion: { error in
                            if let error = error {
                                print("Error updating profile image: \(error)")
                                completion(error)
                                withAnimation{
                                    showLoadingIndicator = false
                                }
                                
                            } else {
                                print("Profile image successfully updated")
                                completion(nil)
                                withAnimation{
                                    showLoadingIndicator = false
                                }
                            }
                        }
                    )

                    
            
                    
                   
                }
                
           
                
               
                
                
            }
            
        }
    }
}

#Preview {
    ChangeProfilePictureView()
        .environmentObject(UserProfileModel())
        
}



