//
//  ProfileView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI
import Firebase
import NavigationStack


struct ProfileView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack

    /// id of view
    static let id = String(describing: Self.self)
    
     @EnvironmentObject private var account: Account
    
    @ObservedObject var settings = Settings.shared

    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String = ""


    var body: some View {
        
       
            
              
                
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
                    
                }.alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.logout), perform: { _ in
                
                    goBackToSignInRootView()
            
            })
                
             .onAppear(perform: {
                
                
            
                doneWithSignUp()
                account.listen_for_user_data_updates()
                account.listenOnlyForSignOut()
                
        })
        
        
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
                
                
                
            }
            
       

        }

    }
    
    func goBackToSignInRootView()  {

        navigationStack.pop(to: .root)
    }
    
    func MakeProfileImage() -> some View {
        return EmptyView()
        /*
        return AsyncImage(url: URL(string: (account.data?.profile_image_url) ?? ""))
            .frame(width: 200, height: 200, alignment: .center)
 */
    }
    
    func MakeQRCode() -> some View {
        
        return  Image(uiImage: generateQRCode(from: account.data?.id ?? ""))
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }
    
    

    func doneWithSignUp()  {
        
        settings.viewType = .main
    }
    
    
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        
            
            ProfileView().environmentObject(Account())
            //.environmentObject(NavigationModel())
                          //  .preferredColorScheme(.dark)
        
        
            
    }
}



