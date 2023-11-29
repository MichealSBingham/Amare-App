//
//  ExtraMediaUploadView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/29/23.
//

import SwiftUI

struct ExtraMediaUploadView: View {
    @EnvironmentObject var model: OnboardingViewModel
    
    @StateObject var viewModel: ExtraMediaUploadViewModel = ExtraMediaUploadViewModel()
    
    @State var showPicker1: Bool = false
    @State var showPicker2: Bool = false
  
    @State var showLoadingIndicator: Bool = false
    
    @State var errorDidHappen: Bool = false
    @State var error: Error?
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
         
                Text("Beautiful.")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .padding()
            
            
            Text("Upload **2 more** to use Amare for **Dating**.")
               
            
            
            HStack{
                
                image1PickerButton()
                    .padding(.horizontal)
                image2PickerButton()
                    .padding(.horizontal)
            }
            .padding()
            
            Button {
                model.datingSelected = false
                withAnimation{
                    model.currentPage = .username
                }
                
            } label: {
                Text("I'm not using Amare for dating.")
            }

            
            NextButtonView(text: showLoadingIndicator ? "Please Wait ... " :  "Next") {
                withAnimation {
                    beginImagesUpload { error in
                        guard error == nil else {
                            return
                        }
                        model.currentPage = .username
                    }
                    
                }
            }
            
            .disabled(
                ((viewModel.croppedProfileImage1 == nil && viewModel.croppedProfileImage2 == nil) || showLoadingIndicator ) ? true: false
            )
            .opacity(((viewModel.croppedProfileImage1 == nil && viewModel.croppedProfileImage2 == nil) || showLoadingIndicator ) ? 0.5: 1 )
            
            
           
            
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
    
    private func image1PickerButton() -> some View {
        Button {
            withAnimation{
                showPicker1.toggle()
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
            show: $showPicker1,
            originalImage: $viewModel.originalProfileImage1,     // Binding to the original image
            croppedImage: $viewModel.croppedProfileImage1
            
        )
    }
    
    private func image2PickerButton() -> some View {
        Button {
            withAnimation{
                showPicker2.toggle()
            }
        } label: {
            if let image = viewModel.croppedProfileImage2{
                
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
            show: $showPicker2,
            originalImage: $viewModel.originalProfileImage2,     // Binding to the original image
            croppedImage: $viewModel.croppedProfileImage2
            
        )
    }
    
    func beginImagesUpload(completion: @escaping  (Error?) -> Void ){
        withAnimation{
            showLoadingIndicator = true
        }
        
        if let cropImage1 = viewModel.croppedProfileImage1, let orgImage1 = viewModel.originalProfileImage1,
           let cropImage2 = viewModel.croppedProfileImage2,
           let orgImage2 = viewModel.originalProfileImage2{
            
            viewModel.uploadExtraImages { firstCroppedURL, firstOriginalURL, secondCroppedURL, secondOriginalURL, error in
                
                guard error == nil else {
                    DispatchQueue.main.async{
                        self.error = error
                        errorDidHappen = true
                        showLoadingIndicator = false
                        viewModel.croppedProfileImage1 = nil
                        viewModel.croppedProfileImage2 = nil
                        viewModel.originalProfileImage1 = nil
                        viewModel.originalProfileImage2 = nil
                    }
                    return 
                }
                
                //Set image url to onboarding model
                DispatchQueue.main.async {
                    
                 
                    
    
                    
                    model.extraImages.removeAll()
                    model.extraImages.append(firstCroppedURL?.absoluteString ?? "")
                    model.extraImages.append(secondCroppedURL?.absoluteString ?? "")
                    
            
                    showLoadingIndicator = false
                    completion(nil)
                }
                

                
                
            }
            
            
            
            
            
            
          
            
        }
    }
    
}

#Preview {
    ExtraMediaUploadView()
        .environmentObject(OnboardingViewModel())
}
