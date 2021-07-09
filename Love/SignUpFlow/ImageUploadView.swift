//
//  ImageUploadView.swift
//  Love
//
//  Created by Micheal Bingham on 7/2/21.
//

import SwiftUI

@available(iOS 15.0, *)
@available(iOS 15.0, *)
@available(iOS 15.0, *)
struct ImageUploadView: View {
    
    @EnvironmentObject private var account: Account
    
    
    @State private var goToNext: Bool = false
    
    
    @State var showImagePicker: Bool = false
    
    @State var image: UIImage?

    @State var profileimage: UIImage?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    
    var body: some View {
        
        
        ZStack {
            
            SetBackground()
            
            // ******* ======  Transitions -- Navigation Links =======
            //                                                      //
            //                Goes to the Profile                   //
            //                                                      //
         /* || */           NavigationLink(                       /* || */
        /* || */   destination: ProfileView().environmentObject(account),
        /* || */           isActive: $goToNext,                  /* || */
        /* || */           label: {  EmptyView()  })             /* || */
        /* || */                                                 /* || */
        /* || */                                                 /* || */
            // ******* ================================ **********
            
            
            VStack {
                
                Spacer()
                                
                HStack{
        
                    ButtonForSelectingImage()
                    ButtonForSelectingImage2()
                    ButtonForSelectingImage3()
                    ButtonForSelectingImage4()
                }
                
              Spacer()
            
                       
                
               
                
                
                
                Button("Upload") {
               
                    account.upload(image: image!, isProfileImage: true) { error in
                        
                        if let error = error{
                            print("There was some error ")
                            goToNext = false
                        }
                        
                        print("Image uploaded. ")
                    }
                }
                
                Button("Next") {
                    goToNext = true
                }
                
                
                
                
                Spacer()
                
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(sourceType: .photoLibrary) { image in
                            self.image = image
                        }
                }
            
                    
        }.onAppear {
            doneWithSignUp(state: false)
        }
        
            
        
    
        
        
    }
    
    
    
    
    
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================
    // PUT ALL FUNCTIONS RELATED TO BUILDING THE UI HERE.
    
    
    
    
    

    
    
    func SetBackground() -> some View {
        
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Upload Profile Images")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    }
    
    
    func ButtonForSelectingImage() -> some View {
        
        if image != nil {
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        return Button("Pick image") {
            self.showImagePicker.toggle()
                
        }
    }
    
    func ButtonForSelectingImage2() -> some View {
        
        if image != nil {
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        return Button("Pick image") {
            self.showImagePicker.toggle()
        }
    }
    
    func ButtonForSelectingImage3() -> some View {
        
        if image != nil {
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        return Button("Pick image") {
            self.showImagePicker.toggle()
        }
    }

    
    func ButtonForSelectingImage4() -> some View {
        
        if image != nil {
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        return Button("Pick image") {
            self.showImagePicker.toggle()
        }
    }


    
    func ButtonForSelectingProfileImage() -> some View {
        
        if profileimage != nil {
            Image(uiImage: profileimage!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        return Button("Pick image") {
            self.showImagePicker.toggle()
        }
    }
    
    
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================
    
}

@available(iOS 15.0, *)
@available(iOS 15.0, *)
struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {ImageUploadView().preferredColorScheme(.dark).environmentObject(Account())}
    }
}
