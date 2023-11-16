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
    
  
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
         
                Text("Let's see what you look like? 😏")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .padding()
               
            
            
            HStack{
                
                EditableCircularProfileImage(viewModel: viewModel)
                    
            }
            .padding()
            
            NextButtonView(text: viewModel.urlToProfileImage.isEmpty ? "Skip" : "Next") {
                withAnimation {
                    
                    model.profileImageUrl = viewModel.urlToProfileImage
                    model.currentPage = .username
                }
            }
            
            
            
            Spacer()
            Spacer()
            
        }
        .alert(isPresented: $viewModel.errorDidHappen, content: {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        })
       
    }
}

#Preview {
    MediaUploadView()
        .environmentObject(OnboardingViewModel())
}
