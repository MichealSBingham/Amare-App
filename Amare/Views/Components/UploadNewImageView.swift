//
//  UploadNewImageView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/29/23.
//

import SwiftUI



struct UploadNewImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: UserProfileModel
    
    @StateObject var viewModel: ExtraMediaUploadViewModel = ExtraMediaUploadViewModel()
    
    @State var showPicker: Bool = false
  
    @State var showLoadingIndicator: Bool = false
    
    @State var errorDidHappen: Bool = false
    @State var error: Error?
    
    
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
         
                Text("Upload Another Picture")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .padding()
               
            
            
            HStack{
                
                                
                image1PickerButton()
                


                
                
                    
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
            
            .disabled((viewModel.croppedProfileImage1 == nil || showLoadingIndicator ) ? true: false )
            .opacity((viewModel.croppedProfileImage1 == nil || showLoadingIndicator) ? 0.5: 1 )
            
           
            
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
    
    private func image1PickerButton() -> some View {
        Button {
            withAnimation{
                showPicker.toggle()
            }
        } label: {
            if let image = viewModel.croppedProfileImage1{
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .border(Color.secondary, width: 2)
                 
            }
            else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }

        }
        .buttonStyle(.plain)
        .cropSquareImagePicker(
            options: [.circle, .square, .rectangle, .custom(.init(width: 350, height: 450))],
            show: $showPicker,
            originalImage: $viewModel.originalProfileImage1,     // Binding to the original image
            croppedImage: $viewModel.croppedProfileImage1
            
        )
    }
    
    func beginImageUpload(completion: @escaping  (Error?) -> Void ){
        withAnimation{
            showLoadingIndicator = true
        }
        
        if let cropImage = viewModel.croppedProfileImage1, let orgImage = viewModel.originalProfileImage1{
            
            // Upload the image
            viewModel.uploadImage { croppedImageUrl, originalImageURl, error in
                
                
                
                guard error == nil else {
                    print("===error is not nil=== ")
                    DispatchQueue.main.async {
                        self.error = error
                        errorDidHappen = true
                        showLoadingIndicator = false
                        viewModel.croppedProfileImage1 = nil
                        viewModel.originalProfileImage1 = nil
                        completion(error)
                    }
                     
                    return
                }
                
              
                
                
                let oldImages = dataModel.user?.images  ?? []
                
                let username = dataModel.user?.username ?? ""
                
                //Set the new image url
                DispatchQueue.main.async {
                    
                 // Update images
                    FirestoreService.shared.addNewImage(imageURL: originalImageURl?.absoluteString ?? "", imagesArray: oldImages) { error in
                        
                        if let error = error {
                            print("Error adding  new image: \(error)")
                            completion(error)
                            withAnimation{
                                showLoadingIndicator = false
                            }
                            
                        } else {
                            print("new image successfully added")
                            completion(nil)
                            withAnimation{
                                showLoadingIndicator = false
                            }
                        }
                        
                    }
                    
             
                    
            
                    
                   
                }
                
           
                
               
                
                
            }
            
        }
    }
}



#Preview {
    UploadNewImageView()
        .environmentObject(UserProfileModel())
}
