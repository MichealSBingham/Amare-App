//
//  ProfileView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI
import Firebase
import NavigationStack

@available(iOS 15.0, *)
struct ProfileView: View {
    
    /// To manage navigation
   // //@EnvironmentObject var navigation: NavigationModel
    
    /// id of view
    static let id = String(describing: Self.self)
    
     @EnvironmentObject private var account: Account
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String = ""


    var body: some View {
        
        NavigationStackView {
            
            ZStack{
               SetBackground()
              
                
                VStack{
                    
                    Spacer()
                    
                    Text(account.data?.name ?? "First Name Last Name")
                    
                    Spacer()
                    
                        
                        MakeProfileImage()
                        MakeQRCode()
                
                    
                    Spacer()
                    
                    MakeSignOutButton()

                    
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                }
                
            } .onAppear(perform: {
                
                
            
                doneWithSignUp()
                account.listen_for_user_data_updates()
                account.listenOnlyForSignOut()
                
        })
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================
    // PUT ALL FUNCTIONS RELATED TO BUILDING THE UI HERE.
    
    
    func SetBackground() -> some View {
        
        return Image("backgrounds/background2")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(account.data?.name ?? "Profile")
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.logout), perform: { _ in
                
            // NavigationUtil.popToRootView()
            
            })
        
    }
    
    
    func MakeSignOutButton() -> some View {
        
        return   Button("Sign Out") {
            // Signs out of profile
            
            account.signOut { error in
                
                guard error == nil else{
                    someErrorOccured = true
                    alertMessage = "Some error when trying to sign out"
                    return
                }
                goBackToRootView()
                
                
            }
            
       

        }

    }
    
    func goBackToRootView()  {

       // //navigation.hideViewWithReverseAnimation(RootView.id)
            
        /* let animation = NavigationAnimation(
            animation: .easeInOut(duration: 0.8),
            defaultViewTransition: .static,
            alternativeViewTransition: .opacity
        )
       
        
        navigation.showView(ProfileView.id, animation: animation) {
            
            RootView().environmentObject(navigation)
                            .environmentObject(account)
                           
            
        }
        */
    }
    
    func MakeProfileImage() -> some View {
        
        return AsyncImage(url: URL(string: (account.data?.profile_image_url) ?? ""))
            .frame(width: 200, height: 200, alignment: .center)
    }
    
    func MakeQRCode() -> some View {
        
        return  Image(uiImage: generateQRCode(from: account.data?.id ?? ""))
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }
    
    
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================

    
    
    
    
    
}

@available(iOS 15.0, *)
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        
            
            ProfileView().environmentObject(Account())
            //.environmentObject(NavigationModel())
                          //  .preferredColorScheme(.dark)
        
        
            
    }
}
