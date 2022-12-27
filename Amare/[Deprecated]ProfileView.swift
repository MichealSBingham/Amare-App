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

        //navigationStack.pop(to: .root)
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
        
        
            
        RotatingGradientView()
            //.environmentObject(NavigationModel())
                          //  .preferredColorScheme(.dark)
        
        
            
    }
}





struct RotatingGradientView: View {
    @State var gradientAngle: Double = 0
    
     var colors = [ Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
                   Color(UIColor(red: 0.94, green: 0.16, blue: 0.77, alpha: 1.00)) ]
    
    var body: some View {
        ZStack {
            Rectangle()
            .fill(AngularGradient(gradient: Gradient(colors: colors), center: .center, angle: .degrees(gradientAngle)))  .edgesIgnoringSafeArea(.all)
           // .brightness(0.2)
           // .saturation(0.7)
            .blur(radius: 5)
            
            
            
            
        }
      
        .onAppear {
            withAnimation(Animation.linear(duration: 12).repeatForever(autoreverses: false)) {
                self.gradientAngle = 360
            }
        }
    }
}
