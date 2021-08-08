//
//  SignInOrUpView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/8/21.
//

import SwiftUI
import NavigationStack

struct SignInOrUpView: View {
    
    static let id = String(describing: Self.self)
    @EnvironmentObject private var account: Account
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    /// Terms and conditions
    @State private var termsAreAccepted: Bool = false
    
    /// Attempts the user tried to tap signin/signout without accepting terms. This is so that we can animate the view , see the modifier on accepting terms view to understand
    @State private var attempts: Int = 0

    
    /// Help needed
    @State private var needsHelp: Bool = false
    
    /// By default, we let the sign up and sign in buttons to be enabled purely just for asthetic reasons when the user opens the app.
    @State private var signInandSignUpAreEnabled: Bool = true

    
    @State public var beginAnimation: Bool = false
    @State private var toggledAnimationAlready: Bool = false
    @GestureState  var isTappingLogoAndTagline: Bool = false
    
    @State private var language: Language = .Latin
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            createLogo()
            
            createTextAndTaglineForLogo()
            
            Spacer()
            
            Group{
                
                createSignInButton()
                createSignUpButton()
                
                
            }
            
            
            
            Spacer()
            Spacer()
            
            createPolicyAndConditionsAcceptance()
            
            Spacer()
            
            needHelp()
            
            
            
        }
    }
    
    
    
    /// Creates the logo for the view
    func createLogo() -> some View {
        
        return Group{
            ZStack{ ringImage() ; moleculeImage()  }
            ZStack{ verticleCrossImage() ; horizontalCrossImage() }
        }   .offset(y: beginAnimation ? -15: 0 )
            .animation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: {  withAnimation{beginAnimation = true}})

    }
    
    /// 'Amare' and 'Love Conquers All' Text under the logo. Language changes when  you tap it and every few moments
    func createTextAndTaglineForLogo() -> some View  {
        
        return Group {
            AmareText(language: language)
            taglineText(language: language)
        }.onTapGesture {
            language.toggle()
        }
    }
    /// Returns the box and the policy and conditions terms the user needs to accept. It's the label at the bottom.
    func createPolicyAndConditionsAcceptance() -> some View  {
        
        return HStack{  box(); agreeToPolicyText }.modifier(ShakeEffect(shakes: attempts*2)).animation(Animation.default, value: attempts)
    }
    
    /// Amare text view below the logo
    func AmareText(language : Language) -> some View {
        
        let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()
        
        return Text(language == .Latin ? "AMARE": "LOVE")
                .foregroundColor(.white)
                .font((Font.custom("MontserratAlternates-SemiBold", size: 35))
                .bold()
                .weight(.heavy))
                .padding(1)
                .modifier(FadeModifier(control: (language == .Latin)))
                .animation(.easeInOut(duration: 2.5)) // Duration of the fade animation
                .onReceive(timer) { _  in
                    self.language.toggle()
                }
                
        
            
    }
    
    /// Tagline text view below the logo
    func taglineText(language: Language) -> some View {
        
        return Text(language == .Latin ? "Amor Vincit Omnia.": "Love Conquers All.")
           .foregroundColor(.white)
           .font((Font.custom("MontserratAlternates-SemiBold", size: 17)))
           .shimmering(duration: 3)
           .modifier(FadeModifier(control: (language == .Latin)))
           .animation(.easeInOut(duration: 2.5)) // Duration of the fade animation
    
                  
    }
    
    /// The molecule (center) part of the logo (image)
    private func moleculeImage() -> some View {
        
        return Image("branding/molecule")
             .resizable()
            .scaledToFit()
            .frame(width: 70, height: 59)
           
    }
    
    /// The ring part of the logo (Image)
    private func ringImage() -> some View {
        
        return Image("branding/ring")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
        
           
    }
    
    ///The horizontal  part of the cross that's a part of the logo
    private func horizontalCrossImage() -> some View {
        
        return Image("branding/cross-h")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 6)
    }
    
    /// The verticle part of the cross that's a part of the logo
    private func verticleCrossImage() -> some View {
        
        return Image("branding/cross-v")
            .resizable()
            .scaledToFit()
            .frame(width: 7, height: 56)
            .offset(x: 0, y: -8)
            
            
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
    
    /// Sign in text on the sign in button
    private func signInText() -> some View {
        
        return Text("Sign In")
              .foregroundColor(.white)
              .fontWeight(.medium)
              .font(.system(size: 16))
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
    
    /// Sign up text on the sign up button
    private func signUpText() -> some View {
        
        return Text("Sign Up")
            .foregroundColor(.white)
            .fontWeight(.medium)
            .font(.system(size: 16))

    }
    
    /// Rectange image for the sign in and sign up buttons
    private func rectangle() -> some View {
        
        return Image("RootView/rectangle")
            .resizable()
            .scaledToFill()
            .frame(width: 350, height: 50)
    
            
            
    }
    
    /// Right arrow image
    private func rightArrow() -> some View {
        
        return Image("RootView/right-arrow")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 50)
            .offset(x: beginAnimation ? 7: 0 )
            .animation(.easeInOut(duration: 2.3).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: withAnimation{{beginAnimation = true}})
            
            
            
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
    private func boxImage() -> some View {
        
        return Image("RootView/box")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .padding(-2)
    }
    
    /// Returns image of a filled box (for the terms and policy acceptance)
    private func box_filled() -> some View {
        
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
    private func needHelpText() -> some View {
        
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
        
        self.navigationStack.push(EnterPhoneNumberView())
        
        
    }
}

struct SignInOrUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInOrUpView()
    }
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
