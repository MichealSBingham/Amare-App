//
//  MediaUploadView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/15/23.
//

import SwiftUI





struct MediaUploadView: View {
    @EnvironmentObject var model: OnboardingViewModel
    
    @StateObject var viewModel: MediaUploadModel = MediaUploadModel()
    
    @State var showPicker: Bool = false
  
    @State var showLoadingIndicator: Bool = false
    
    @State var errorDidHappen: Bool = false 
    @State var error: Error?
    
    
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
         
                Text("Let's see what you look like? 😏")
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
                         /*   .onAppear {
                                
                                
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
                                            }
                                             
                                            return
                                        }
                                        
                                        //Set image url to onboarding model
                                        DispatchQueue.main.async {
                                            
                                            model.profileImageUrl = croppedImageUrl?.baseURL?.absoluteString ?? ""
                                            
                                            model.images.removeAll()
                                            
                                            model.images.append(originalImageURl?.baseURL?.absoluteString ?? "")
                                        }
                                        
                                        
                                        
                                        withAnimation{
                                            showLoadingIndicator = false
                                        }
                                        
                                        print("profile image url is \(model.profileImageUrl)")
                                        
                                        
                                    }
                                    
                                }
                            }
                          */
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
            
            NextButtonView(text: showLoadingIndicator ? "Please Wait ... " :  "Next") {
                withAnimation {
                    beginImageUpload { error in
                        guard error == nil else {
                            return
                        }
                        model.currentPage = .extraImageUpload
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
                
                //Set image url to onboarding model
                DispatchQueue.main.async {
                    
                 
                    
                    model.profileImageUrl = croppedImageUrl?.absoluteString ?? ""
    
                    
                    model.images.removeAll()
                    model.images.append(originalImageURl?.absoluteString ?? "")

                    
            
                    showLoadingIndicator = false
                    completion(nil)
                }
                
           
                
               
                
                
            }
            
        }
    }
}

#Preview {
    MediaUploadView()
        .environmentObject(OnboardingViewModel())
}
