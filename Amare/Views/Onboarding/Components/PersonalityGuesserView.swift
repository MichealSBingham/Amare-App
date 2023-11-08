//
//  PersonalityGuesserView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/8/23.
//

import SwiftUI

struct PersonalityGuesserView: View {
    @EnvironmentObject  var viewModel: OnboardingViewModel
    @State private var activeTabIndex = 0
    @State private var introText = "Let's explore your personality in **deeper** detail."
   
    let introMessages = [
        "Let's explore your personality in **deeper** detail.",
        "We'll tell you what our **AI** thinks about you thus far.",
        "Your feedback sharpens its **intuition** about you.",
        "Again, if you **agree** with the statement, say so.",
        "If you **disagree** with the statement, say so.",
        "Let's begin!"
    ]
    
    @State private var showIntroText: Bool = true
    
    @State var currentStatement: PersonalityStatement?
    
    @State var animateThumbsUp: Bool = false
    @State var animateThumbsDown: Bool = false
    
    @State var finished: Bool = false
    @State var finished2: Bool = false
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                
                ZStack{
                    RadialChart(progress: viewModel.correctnessPercentageForPersonality)
                        .offset(y: !finished ? -130 : 0 )
                        .opacity(!finished2 ? 1: 0 )
                    
                    Text(viewModel.correctnessPercentageForPersonality < 0.55 ? "The more you **use Amare**.\nThe more we **understand you**." : "We were **\(Int((viewModel.correctnessPercentageForPersonality * 100).rounded()))% correct**.\nThat's better than guessing!🔥")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .opacity(finished2 ? 1: 0 )
                }
                
            }
            .onChange(of: activeTabIndex) {  tab in
                if tab == viewModel.predictedPersonalityStatements.count   {
                    withAnimation {
                        finished = true
                        
                        AmareApp().delay(1) {
                            withAnimation{
                                finished2 = true
                            }
                           
                        }
                    }
                }
            }
            
            Text(.init(introText))
                .multilineTextAlignment(.center)
                .font(.title)
                .shadow(radius: 5)
                .padding()
                .tag(0)
                .onReceive(timer) { _ in
                    let nextIndex = introMessages.firstIndex(of: introText)! + 1
                    if nextIndex < introMessages.count {
                        if nextIndex == 2 {
                            thumbsUp()
                        }
                        if nextIndex == 3 {
                            thumbsDown()
                        }
                        if nextIndex == 5 {
                            thumbsUp()
                        }
                        withAnimation {
                            introText = introMessages[nextIndex]
                            
                        }
                        
                    } else {
                        //activeTabIndex = 1
                        timer.upstream.connect().cancel() // Stop the timer
                        withAnimation { showIntroText = false }
                        
                    }
                }
                .opacity(showIntroText ? 1: 0 )
            
            TabView(selection: $activeTabIndex) {
                
                
                ForEach(Array(viewModel.predictedPersonalityStatements.enumerated()), id: \.element.description) { (index, statement) in
                    PersonalityFeedbackCardView(statement: statement.description)
                    .onAppear { self.currentStatement  = statement }
                    .tag(index)
                    
                
                }
                
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .opacity(!showIntroText && !finished ? 1: 0 )
            
            ProgressView()
                .opacity(viewModel.predictedPersonalityStatements.isEmpty && !showIntroText ? 1: 0 )
            
            //This *was* in trait feedback card but we want to move it out of the page view
            VStack {
                Spacer()
                HStack{
                    Button(action: {
                       
                        
                        viewModel.personalityStatementsFeedback[viewModel.predictedPersonalityStatements[activeTabIndex].description] = false
                        
                        withAnimation { animateThumbsDown.toggle();
                            AmareApp().delay(0.3) {
                                animateThumbsDown.toggle()
                            }
                        }
                        
                        withAnimation { activeTabIndex += 1 }
                    }) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .rotationEffect(.degrees(animateThumbsDown ? -40 : 0)) // Rotates counterclockwise
                    .offset(y: animateThumbsDown ? 20 : 0) // Moves in an arc
                    .animation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0), value: animateThumbsDown)
                    .disabled(showIntroText)
                    .opacity(!finished ? 1 : 0 )
                    
                    
                    Button(action: {
                        
                        viewModel.personalityStatementsFeedback[viewModel.predictedPersonalityStatements[activeTabIndex].description] = true
                        
                        withAnimation { animateThumbsUp.toggle();
                            AmareApp().delay(0.3) {
                                animateThumbsUp.toggle()
                            }
                        }
                        
                        withAnimation { activeTabIndex += 1 }
                        
                    }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundColor(.green)
                    }
                    .rotationEffect(.degrees(animateThumbsUp ? -40 : 0)) // Rotates counterclockwise
                    .offset(y: animateThumbsUp ? -20 : 0) // Moves in an arc
                    .animation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0), value: animateThumbsUp)
                                
                    .disabled(showIntroText)
                    .opacity(!finished ? 1 : 0 )
                    
                }
            }
            
        }
        .onAppear {
            activeTabIndex = 0
        }
    }
    
    func thumbsUp()  {
        withAnimation { animateThumbsUp.toggle();
            AmareApp().delay(0.3) {
                animateThumbsUp.toggle()
            }
        }
    }
    
    func thumbsDown()  {
        withAnimation { animateThumbsDown.toggle();
            AmareApp().delay(0.3) {
                animateThumbsDown.toggle()
            }
        }
    }
}

struct PersonalityFeedbackCardView: View {
    let statement: String
   
    

    var body: some View {
        ZStack {
    
                Text(statement)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.1)
                    .padding()
            
            
            
            
           
        }
        
      //  .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}


#Preview {
    PersonalityGuesserView()
        .environmentObject(OnboardingViewModel())
}
