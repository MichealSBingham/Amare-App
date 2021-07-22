//
//  RootView.swift
//  Love
//
//  Created by Micheal Bingham on 6/22/21.
//

import SwiftUI
import Shimmer
import NavigationStack

@available(iOS 15.0, *)
struct RootView: View {
    
    static let id = String(describing: Self.self)
    @EnvironmentObject private var account: Account
    
    
    
    /// Terms and conditions
    @State private var termsAreAccepted: Bool = false
    
    /// Attempts the user tried to tap signin/signout without accepting terms. This is so that we can animate the view , see the modifier on accepting terms view to understand
    @State private var attempts: Int = 0

    
    /// Help needed
    @State private var needsHelp: Bool = false
    
    /// By default, we let the sign up and sign in buttons to be enabled purely just for asthetic reasons when the user opens the app.
    @State private var signInandSignUpAreEnabled: Bool = true

    
    @State private var beginAnimation: Bool = false
    @GestureState  var isTappingLogoAndTagline: Bool = false
    
    @State private var language: Language = .Latin
    
    @EnvironmentObject var navigation: NavigationModel

    
    var body: some View {
        
        
     
        NavigationStackView(RootView.id) {
            
            
        

            ZStack {
                
       
                
                Group{
                    
                    if account.isSignedIn{
                        // Go to the profile if signed in
                        ProfileView().environmentObject(self.account)
                        
                    } else{
                        
                        // Show sign in screen
                        
                        ZStack{
                            
                            
                            let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()

                          AnimatedBackground()
                                .onReceive(timer) { _ in language.toggle() }
                                
                           
                            
                            VStack{
                                
                               Spacer()
                                
                                createLogo()
                                
                                Group{
                                AmareText(language: language)
                                taglineText(language: language)
                                }.onTapGesture {
                                    language.toggle()
                                }
                                
                            
                                
                                
                                Spacer()
                               
                                Group{
                                    createSignInButton()
                                    createSignUpButton()
                                }
                                
                                
                                
                                Spacer()
                                Spacer()
                                
                    
                                HStack{  box(); agreeToPolicyText }.modifier(ShakeEffect(shakes: attempts*2)).animation(Animation.default, value: attempts)
                                
                                
                                Spacer()
                                
                                needHelp()
                                
                                
                                
                            }
                           
                          
                        }
                        
                        
                    }
                } // On Group View
                .onDisappear(perform: { account.stopListening() })
                .alert(isPresented: $needsHelp) { Alert(title: Text("ToDo: Password Reset"), message: Text("This is not finished yet. Contact me (Micheal) if you need assistance. (917).699.0590 or micheal@xiris.ai")) }
                
                
            }
            
            
        }
        
       
       
        
    }
    
    /// Creates the logo image for the view (The Amare Logo)
    func createLogo() -> some View {
        
        return Group{
            ZStack{ ringImage() ; moleculeImage()  }
            ZStack{ verticleCrossImage() ; horizontalCrossImage() }
        }   .offset(y: beginAnimation ? -15: 0 )
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: {withAnimation{beginAnimation = true}})
    }
    
    /// Creates the sign in button for the view
    func createSignInButton() -> some View {
        
        
        
        return  Button {
            
                // Pressed sign in button
            guard termsAreAccepted else {
                
                // User did not accept terms and conditions,
                
                signInandSignUpAreEnabled = false // disable the button
            
               
                attempts+=1
            
                
                return
            }
            
           
          goToNextView()
            
        } label: {
            // Creating the view
            
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
        }.opacity(signInandSignUpAreEnabled ? 1: 0.5)
            

        
    }
    
    /// Creates the sign up button for the view
    func createSignUpButton() -> some View {
        
        
        return Button {
            
            guard termsAreAccepted else {
                
                signInandSignUpAreEnabled = false
                
                attempts+=1
                
                return
            }
            
            
            goToNextView()
            
        } label: {
            
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
        }.opacity(signInandSignUpAreEnabled ? 1: 0.5)

        
    
    }
    
    /// The molecule (center) part of the logo (image)
    func moleculeImage() -> some View {
        
        return Image("branding/molecule")
             .resizable()
            .scaledToFit()
            .frame(width: 70, height: 59)
           
    }
    
    /// The ring part of the logo (Image)
    func ringImage() -> some View {
        
        return Image("branding/ring")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
        
           
    }
    
    ///The horizontal  part of the cross that's a part of the logo
    func horizontalCrossImage() -> some View {
        
        return Image("branding/cross-h")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 6)
    }
    
    /// The verticle part of the cross that's a part of the logo
    func verticleCrossImage() -> some View {
        
        return Image("branding/cross-v")
            .resizable()
            .scaledToFit()
            .frame(width: 7, height: 56)
            .offset(x: 0, y: -8)
            
            
    }
    
    /// Amare text view below the logo
    func AmareText(language : Language) -> some View {
        
        /*
    return Image("branding/Amare-text")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 100)
            .padding(.top, -35)
            .padding(.bottom, -35)
        */
        
        return Text(language == .Latin ? "AMARE": "LOVE")
                .foregroundColor(.white)
                .font((Font.custom("MontserratAlternates-SemiBold", size: 35))
                .bold()
                .weight(.heavy))
                .padding(1)
                .modifier(FadeModifier(control: (language == .Latin)))
                .animation(.easeInOut(duration: 2.5)) // Duration of the fade animation
                
                
        
            
    }
    
    /// Tagline text view below the logo
    func taglineText(language: Language) -> some View {
        /*
        return Image("branding/tagline")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .padding(.top, -88)
            .padding(.bottom, -85)
        
        */
        return Text(language == .Latin ? "Amor Vincit Omnia.": "Love Conquers All.")
           .foregroundColor(.white)
           .font((Font.custom("MontserratAlternates-SemiBold", size: 17)))
           .shimmering(duration: 3)
           .modifier(FadeModifier(control: (language == .Latin)))
           .animation(.easeInOut(duration: 2.5)) // Duration of the fade animation
    
                  
    }
        
    /// Rectange image for the sign in and sign up buttons
    func rectangle() -> some View {
        
        return Image("RootView/rectangle")
            .resizable()
            .scaledToFill()
            .frame(width: 350, height: 50)
    
            
            
    }
    
    /// Sign up text on the sign up button
    func signUpText() -> some View {
        
        return Text("Sign Up")
            .foregroundColor(.white)
            .fontWeight(.medium)
            .font(.system(size: 16))

    }
    
    /// Sign in text on the sign in button
    func signInText() -> some View {
        
        return Text("Sign In")
              .foregroundColor(.white)
              .fontWeight(.medium)
              .font(.system(size: 16))
    }
        
    /// Right arrow image
    func rightArrow() -> some View {
        
        return Image("RootView/right-arrow")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 50)
            .offset(x: beginAnimation ? 7: 0 )
            .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: beginAnimation)
           // .onAppear(perform: {beginAnimation = true})
            
            
            
    }
    
    /// Button for the box to check
    func box() -> some View {
        
        
       return  Button {
            // Box tapped to agree to terms
            termsAreAccepted.toggle()
           signInandSignUpAreEnabled = termsAreAccepted
       
            
        } label: {
        
            if termsAreAccepted{
                
                box_filled()
                
            } else{  boxImage() }
           
        }
            
    }
    
    /// Returns image of a blank box (for terms and policy acceptance)
    func boxImage() -> some View {
        
        return Image("RootView/box")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .padding(-2)
    }
    
    /// Returns image of a filled box (for the terms and policy acceptance)
    func box_filled() -> some View {
        
        return Image("RootView/box-filled")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            
    }
    
    /// Button for 'Need Help?'
    func needHelp() -> some View {
        
        Button {
            needsHelp = true
           
            
        } label: {
            
            needHelpText()
        }

    }
   
    /// Text for the needs help view
    func needHelpText() -> some View {
        
        return Text("Need Help?")
            .foregroundColor(.white)
            .font(.subheadline)
                       
    }
    
    
    /// Text for agreeing to the policy
    private var agreeToPolicyText: some View {
        
        Text(agreeToPolicyTextAttributedString()).foregroundColor(.white).font(.system(size: 16))
    }
    
    /// Function to generate the formatted text for the policy
    func agreeToPolicyTextAttributedString() -> AttributedString{
    
        var attributedString = try! AttributedString(markdown:"I agree to the **9 Laws**, Privacy Policy, Terms, and Cookie Policy.")
        
        let ninelaws = attributedString.range(of: "9 Laws")!
        attributedString[ninelaws].link = URL(string: "https://www.example.com")
        attributedString[ninelaws].foregroundColor = .white
        attributedString[ninelaws].underlineColor = .white
        
        let pp = attributedString.range(of: "Privacy Policy")!
        attributedString[pp].link = URL(string: "https://www.example.com")
        attributedString[pp].foregroundColor = .white
        attributedString[pp].underlineColor = .white
        
        let terms = attributedString.range(of: "Terms")!
        attributedString[terms].link = URL(string: "https://www.example.com")
        attributedString[terms].foregroundColor = .white
        attributedString[terms].underlineColor = .white
        
        let cp = attributedString.range(of: "Cookie Policy")!
        attributedString[cp].link = URL(string: "https://www.example.com")
        attributedString[cp].foregroundColor = .white
        attributedString[cp].underlineColor = .white
        
        
        
        return attributedString
        

        
}
    
    
    /// Goes to the next view. We are using the `NavigationStack` package from GitHub. Open source. It works better than `NavigationView`
    func goToNextView()  {
        
        navigation.showView(RootView.id, animation: nil) { EnterPhoneNumberView() }
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
            .animation(Animation.easeInOut(duration: 2).repeatForever(), value: start) /// don't forget the `value`!
            .onReceive(timer) { _ in
                
                self.start = nextPointFrom(self.start)
                self.end = nextPointFrom(self.end)

            }
            .edgesIgnoringSafeArea(.all)
    }
    
    /// cycle to the next point
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .top:
            return .topLeading
        case .topLeading:
            return .leading
        case .leading:
            return .bottomLeading
        case .bottomLeading:
            return .bottom
        case .bottom:
            return .bottomTrailing
        case .bottomTrailing:
            return .trailing
        case .trailing:
            return .topTrailing
        case .topTrailing:
            return .top
        default:
            print("Unknown point")
            return .top
        }
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


enum Language {
    case English
    case Latin
    
    mutating func toggle()  {
        if self == .English {
            self = .Latin
        } else {
            self = .English
        }
    }
}
