//
//  LoadingView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/12/23.
//

import SwiftUI

struct LoadingView: View {
    
    static let id = String(describing: Self.self)
  
    
    /// Terms and conditions  **iOS 14** , automatically true because we can't include the terms and conditions statement in the ios 14 verison
    @State private var termsAreAccepted: Bool = true
    
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
    
    @State private var buttonDisabled: Bool = false
    
    @State var beginOnboardingFlow: Bool = false
    
    var body: some View {
        
        ZStack{
            Background().environmentObject(BackgroundViewModel())
            VStack{
                createLogo()
                createTextAndTaglineForLogo()
                
            }
        }
       
        
    }
    
    /// Creates the logo for the view
    func createLogo() -> some View {
        
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
        
        
        return Group{
            ZStack{ ringImage() ; moleculeImage()  }
            ZStack{ verticleCrossImage() ; horizontalCrossImage() }
        }   .offset(y: beginAnimation ? -25: 0 )
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
    
    /// Amare text view below the logo
    func AmareText(language : Language) -> some View {
        
        let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()
        
        return Text(language == .Latin ? "AMĀRE": "LOVE")
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
    //Omnia vincit amor: et nos cedamus amori
        // let us too yield to love
        return Text(language == .Latin ? "Amor Vincit Omnia.": "Love Conquers All.")
           .foregroundColor(.white)
           .font((Font.custom("MontserratAlternates-SemiBold", size: 17)))
      //     .shimmering(duration: 3)
           .modifier(FadeModifier(control: (language == .Latin)))
           .animation(.easeInOut(duration: 2.5)) // Duration of the fade animation
    
                  
    }
    
   
 
    
}

#Preview {
    LoadingView()
}
