//
//  BirthdayInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/23/23.
//

import SwiftUI
import EffectsLibrary

struct BirthdayInputView: View {
    
	@EnvironmentObject var model: OnboardingViewModel
	
	/// If this is true, it will adjust the content of the view so that it's for creating another custom profile instead of onboarding the sign up user. i.e. instead of `Enter your name` it'll say `Enter their name`
	var customAccount: Bool = false
    
    var config = FireworksConfig(
            content: [
                .emoji("🕓"),
                .emoji("🕓", 0.1)
            ],
            intensity: .low,
            lifetime: .long,
            initialVelocity: .slow,
            fadeOut: .slow
        )

    
    var body: some View {
        ZStack{
            //SpaceFloatingView()
           // FireworksView(config: config)
            VStack{
                
                
            
                
                
                Spacer()
                
                
                Text(!customAccount ? "When Did Your Cosmic Journey Begin?" : "When Did Their Cosmic Journey Begin?" )
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
                    .padding()
                
                
                
                
                Text(!customAccount ? "Enter your birthday"  : "Enter their birthday" )
                    .font(.system(size: 20))
                //.foregroundColor(.white)
                    .padding()
                
                
                DatePicker("", selection: $model.birthday, in: ...Date().dateFor(years: -13),  displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .padding()
                    .labelsHidden()
                    .environment(\.timeZone, model.homeCityTimeZone ?? .current)
                
                
                NextButtonView {
                    withAnimation {
                        model.currentPage = .birthtime
                    }
                }
                
                
                
                
                
                Spacer()
                
                
                Spacer()
                
                
                
            }
            .onAppear{
                
                // Dismiss the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
            }
            
            
        }
    }
}

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView()
			.environmentObject(OnboardingViewModel())
    }
}



struct SpaceFloatingView: View {
    let emojis: [String] = ["🪨", "🌕", "🛸", "🪐"] // Add more emojis if you like
    let numberOfEmojis = 15 // Number of emojis you want to display
    let screenSize = UIScreen.main.bounds

    var body: some View {
        ZStack {
           
            MovingImageView(speed: 1.5)
                
            ForEach(0..<numberOfEmojis, id: \.self) { index in
                Text(emojis.randomElement() ?? "🪨")
                    .font(.largeTitle)
                    .position(x: CGFloat.random(in: 0...screenSize.width),
                              y: CGFloat.random(in: 0...screenSize.height))
                    .animation(
                        Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5)
                            .repeatForever()
                            .delay(Double.random(in: 0...2)),
                        value: UUID()
                    )
                    .onAppear {
                        // Trigger the animation
                    }
            }
        }
        .opacity(0.15)
    }
}
