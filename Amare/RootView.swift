//
//  RootView.swift
//  Love
//
//  Created by Micheal Bingham on 6/22/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct RootView: View {
    
    @EnvironmentObject private var account: Account
    
    
    var body: some View {
        
        
     
        NavigationView {
            

            Group{
                
                if account.isSignedIn{
                    // Go to the profile if signed in
                    ProfileView().environmentObject(self.account)
                    
                } else{
                    
                    // Show sign in screen
                    
                    ZStack{
                        
                      AnimatedBackground()
                        
                        VStack{
                            
                           // Logo .......................
                            Group{
                                ZStack{ ringImage() ; moleculeImage()  }
                                ZStack{ verticleCrossImage() ; horizontalCrossImage() }
                            }//.border(.white)
                            
                            AmareText()//.border(.white)
                            taglineText()//.border(.white)
                            
                            Spacer()
                           
                            Group{
                                
                                
                                // Sign in // Sign up buttons
                                ZStack{
                                    
                                    rectangle().padding(.bottom, 5)
                                    signInText()
                                    
                                    HStack{
                                        
                                       Spacer()
                                       Spacer()
                                    rightArrow()
                                       Spacer()
                                        
                                    }
                                   
                                    
                                }
                                
                                
                                ZStack{
                                    
                                    rectangle().padding(.bottom, 5)
                                    signUpText()
                                    
                                    HStack{
                                        
                                       Spacer()
                                       Spacer()
                                    rightArrow()
                                       Spacer()
                                        
                                    }
                                   
                                    
                                }
                                
                            }
                            
                            
                            
                            Spacer()
                            
                            Spacer()
                            
                       
                            
                            HStack{  box(); agreeToPolicyText() }
                            
                            Spacer()
                            
                            needHelpText()
                            
                            
                           
                          
                            
                        }
                       
                        
                    }
                    
                    
                    
                }
            } .onDisappear(perform: {
                account.stopListening()
        })
        }
        
       
        
        
    }
    
    
    
    
    
    
    
    func moleculeImage() -> some View {
        
        return Image("branding/molecule")
             .resizable()
            .scaledToFit()
            .frame(width: 70, height: 59)
           
    }
    
    func ringImage() -> some View {
        
        return Image("branding/ring")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
           
    }
    
    func horizontalCrossImage() -> some View {
        
        return Image("branding/cross-h")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 6)
    }
    
    func verticleCrossImage() -> some View {
        
        return Image("branding/cross-v")
            .resizable()
            .scaledToFit()
            .frame(width: 7, height: 56)
            .offset(x: 0, y: -8)
            
            
    }
    
   
    
    func AmareText() -> some View {
        
        return Image("branding/Amare-text")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 100)
            .padding(.top, -35)
            .padding(.bottom, -35)
            
            
            
    }
    
    
    func taglineText() -> some View {
        return Image("branding/tagline")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .padding(.top, -88)
            .padding(.bottom, -75)
          
    }
    
    
    func rectangle() -> some View {
        
        return Image("RootView/rectangle")
            .resizable()
            .scaledToFill()
            .frame(width: 350, height: 50)
    
            
            
    }
    
    
    func signUpText() -> some View {
        
        return Text("Sign Up")
            .foregroundColor(.white)
            .fontWeight(.medium)
            .font(.system(size: 16))

    }
    
    func signInText() -> some View {
        
        return Text("Sign In")
              .foregroundColor(.white)
              .fontWeight(.medium)
              .font(.system(size: 16))
    }
        
    
    func rightArrow() -> some View {
        
        return Image("RootView/right-arrow")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 50)
            .offset(x: -15)
            
            
            
    }
    
    
    func box() -> some View {
        
        return Image("RootView/box")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            //.offset(x: -15)
        
    }
    
    func agreeToPolicyText() -> some View  {
        
        return Text("I agree to the 9 Laws, Privacy Policy, Terms, and Cookie Policy.")
                .foregroundColor(.white)
            
    }
    
    func needHelpText() -> some View {
        
        return Text("Need Help?")
            .foregroundColor(.white)
            .font(.subheadline)
    }
    
    
    
    
}





    
@available(iOS 15.0, *)
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Account())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
    }
}




/// Animated Gradient Background. I get odd behavior with this on device although it works in simulator.
/// -TODO: Make this hypnotic by having tradient rotated in one direction.
struct AnimatedBackground: View {
    @State var start = UnitPoint.leading
    @State var end = UnitPoint.trailing
    
  
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [ Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
                   Color(UIColor(red: 0.94, green: 0.16, blue: 0.77, alpha: 1.00)) ]
    
    
    var body: some View {
        
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 3).repeatForever(), value: start)
            .onReceive(timer, perform: { _ in
                
               
    
                self.start = .trailing
                self.end = .leading
                
                self.start = .top
                self.end = .bottom
                
                self.start =  .bottomTrailing
                self.end = .topLeading
                
             
                
            }).edgesIgnoringSafeArea(.all)
    }
}







func SetBackground() -> some View {
    
    // Background Image
    return Image("RootView/background")
        .resizable()
        .scaledToFill()
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarColor(backgroundColor: .clear, titleColor: .white)
        // .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
 
}
