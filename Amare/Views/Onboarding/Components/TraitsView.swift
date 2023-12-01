//
//  TraitsView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/5/23.
//

import SwiftUI




// View for a single trait card
struct TraitFeedbackCardView: View {
    let trait: String
    let category: TraitCategory
    

    var body: some View {
        ZStack {
            if category == .likely || category == .neutral{
                Text("You are **\(trait)**.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if category == .unlikely{
                Text("Do you agree that you are **not \(trait)**?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            
            
           
        }
        
      //  .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}


struct TraitsView_Previews: PreviewProvider {
    static var previews: some View {
        TraitsFeedbackView( /*finished: .constant(false)*/)
            .environmentObject(OnboardingViewModel())
    }
}



import Combine



struct TraitsFeedbackView: View {
    @EnvironmentObject  var viewModel: OnboardingViewModel
    @State private var activeTabIndex = 0
    @State private var introText = "Take a peek at what our AI thinks about **you**."
    let introMessages = [
        "Take a peek at what our AI thinks about **you**.",
        "Your feedback sharpens its **intuition** about you.",
        "If you **agree** with the statement, say so.",
        "If you **disagree** with the statement, say so.",
        "Pay attention to negative statements like:\nYou are **not a horse**.",
        "You would agree to this because it is **true** (hopefully)."
    ]
    let introMessagesForPersonality = [
        "Let's explore your personality in **deeper** detail.",
        "We'll tell you what our **AI** thinks about you thus far.",
        "Your feedback sharpens its **intuition** about you.",
        "Again, if you **agree** with the statement, say so.",
        "If you **disagree** with the statement, say so.",
    ]
    
    @State private var showIntroText: Bool = true
    
    @State var currentTrait: PredictedTrait?
    
    @State var animateThumbsUp: Bool = false
    @State var animateThumbsDown: Bool = false
    
    @State var finished: Bool = false
    @State var finished2: Bool = false
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    let  timeoutSeconds: Double  = 45
    @State var didTimeout: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                
                ZStack{
                    RadialChart(progress: viewModel.correctnessPercentage)
                        .offset(y: !finished ? -130 : 0 )
                        .opacity(!finished2 ? 1: 0 )
                    
                    Text(viewModel.correctnessPercentage < 0.55 ? "The more you **use Amare**.\nThe more we **understand you**." : "We were **\(Int((viewModel.correctnessPercentage * 100).rounded()))% correct**.\nThat's better than guessing!🔥")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .opacity(finished2 ? 1: 0 )
                }
                
            }
            .onChange(of: activeTabIndex) {  tab in
                if tab == viewModel.predictedTraits.count   {
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
                
                
                ForEach(Array(viewModel.predictedTraits.enumerated()), id: \.element.name) { (index, trait) in
                    TraitFeedbackCardView(trait: trait.name, category: trait.category)
                    .onAppear { self.currentTrait  = trait }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .opacity(!showIntroText && !finished ? 1: 0 )
            
            ProgressView()
                .opacity( viewModel.predictedTraits.isEmpty && !showIntroText && !didTimeout ? 1: 0 )
                .onAppear(perform: {
                    AmareApp().delay(timeoutSeconds) {
                        if viewModel.predictedTraits.isEmpty {
                            // did timeout
                            withAnimation {
                                didTimeout = true
                            }
                        }
                    }
                })
            
            Text("Our servers are overloaded, skip this for now.")
                .opacity(didTimeout ? 1: 0)
            
            //This *was* in trait feedback card but we want to move it out of the page view
            VStack {
                Spacer()
                HStack{
                    Button(action: {
                       
                        
                        viewModel.traitFeedback[viewModel.predictedTraits[activeTabIndex].name] = false
                        
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
                        
                        viewModel.traitFeedback[viewModel.predictedTraits[activeTabIndex].name] = true
                        
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






struct TraitsFeedbackView2: View {
    @EnvironmentObject  var viewModel: OnboardingViewModel
    @State private var activeTabIndex = 0
    @State private var introText = "Take a peek at what our AI thinks about **you**."
    let introMessages = [
        "Take a peek at what our AI thinks about **you**.",
        "Your feedback sharpens its **intuition** about you.",
        "*Agree* or *disagree* with the following:"
    ]
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                RadialChart(progress: viewModel.correctnessPercentage)
                    .offset(y: -120)
            }
            
            
                
               
            
            TabView(selection: $activeTabIndex) {
                Text(.init(introText))
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .shadow(radius: 5)
                    .padding()
                    .tag(0)
                    .onReceive(timer) { _ in
                        let nextIndex = introMessages.firstIndex(of: introText)! + 1
                        if nextIndex < introMessages.count {
                            withAnimation {
                                introText = introMessages[nextIndex]
                            }
                        } else {
                            activeTabIndex = 1
                            timer.upstream.connect().cancel() // Stop the timer
                        }
                    }
                
                ForEach(Array(viewModel.predictedTraits.enumerated()), id: \.element.name) { (index, trait) in
                    TraitFeedbackCardView(trait: trait.name, category: trait.category)
                    .tag(index + 1)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .redacted(reason: viewModel.predictedTraits.isEmpty ? .placeholder : [])

            ProgressView()
                .opacity(viewModel.predictedTraits.isEmpty && (activeTabIndex != 0) ? 1: 0 )
                
        }
        .onAppear {
            activeTabIndex = 0
        }
    }
}



