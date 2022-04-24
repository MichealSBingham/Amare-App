//
//  ProfilePopup.swift
//  Amare
//
//  Created by Micheal Bingham on 10/1/21.
//

import SwiftUI
import UICircularProgressRing
import URLImage
import URLImageStore
import FirebaseAuth
import Combine
import ConfettiSwiftUI
import VTabView
import SkeletonUI
import SPConfetti
import SPIndicator

// Some random data to use as mock
var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],

"https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]

var colors: [Color] = [.gray, .green, .blue, .red, .orange]


struct ProfilePopup: View {
    
    @Binding var user: AmareUser
    
    
    
    @State var exitInfoOnPlacement: Bool = false
    
    @State var showProfilePopup: Bool = false
    
    
    @State var showActionForUser: Bool = false
    @State var showNegativeActionForUser: Bool = false
    @State var showBottomPopup: Bool = false
    @State var infoToShow:String?
    
    
    // Properties for the profile pop up
    @State var synastryscore = RingProgress.percent(0)
    @State var chemistry = RingProgress.percent(0)
    @State var love = RingProgress.percent(0)
    @State var sex = RingProgress.percent(0)
    
    // Indicates whether the user has winked at the user
   // @State var hasWinked: Bool = false // set to false for prod
    
 //   @State var counterForConfetti: Int = 0
    
    
    /// The particular planet /placement the user clicks on on this profile to display
    @State var placementToDisplay: Planet?
    
    // whether or not to show the placmenets/planets 
    @State var showPlacements: Bool = false
    
    @State var selectedBody: Int = 6
    
    /// For showing redacted animation
    @State var condition: Bool = false
    @State var condition2: Bool = false
    
    @State var tagSelected: Int = 1
    
   //@ObservedObject var viewModelForPlanetView = MoreInfoOnPlanetViewModel()
    
    @State var showConfetti: Bool = false
    @State var showWinkConfetti: Bool = false
    @State var speed: Double = 0
    
    // to animate the lock button
    @State var attempts: Int = 0
    
    @State var attemptsToggle: Bool = false
    
    var body: some View {
       
        ZStack{
        
            ZStack{
            
            
            
            
            VStack{
                
                
                ZStack{
                     
                    
                    if let imgdata = user.image {
                        //print("#Got image data.,,")
                        Button {
                            
                       
                          
                        } label: {
                            
                            
                            Image(uiImage: UIImage(data: imgdata)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                // .frame(width: 100, height: 100)
                                 .shadow(radius: 15)
                                 .frame(width: 150, height: 150)
                        }

                             
                    } else {
                       // print("no image data to reach")
                        profileImageView()
                        
                    }
                    
                  

                    
                   
                    
                    HStack{
                        
                        // For the negative action
                        minusMenuButtonView()
                        
                   
                        
                        Spacer()
                        //For the position actions menu
                        
                        
                        plusMenuButtonView()
                        
                       
                        

                              
                      
                    }
                    
                }
                  
                
                
                
                nameView()
                
                
                classificationView()
                    .redacted(reason: user.synastry_classification == nil ? .placeholder : [])
                
                
                
                ZStack{
                    
                    // Latin Phrase
                    latinPhraseView()
                        .redacted(reason: user.synastry_classification == nil ? .placeholder : [])
                    
                                        
                    
                    //TODO: Make this area more tappable
                    
                    someoneWinkedAtYouView()

    
                    
                }
                
                
                
                // placeholder redaction
                // shown if [natal chart OR  friendship are loading]
               // natal chart = nil ---> rejected permission OR is loading
                // loading if : natal_chart = nil & user.AreFriends = nil
                //
    
                  
                ZStack{
                    
                    tabViewForPlacementsInChart()
                        //.redacted(reason: (user.natal_chart == nil && (user.areFriends == nil && !(user.isNotable ?? false) )) ? .placeholder : [])  // only if it's loading so no error, we check if it's loaded the friendship status because if it has we would rather show the blurr instead of the placeholder
                        .redacted(reason: (user.natal_chart == nil && (user.areFriends == nil )) ? .placeholder : [])
                        .Redacted(reason: (user.areFriends != nil && (user.areFriends == false) && !(user.isNotable ?? false) ) && !(user.id == Auth.auth().currentUser?.uid )  ? .blurredLessIntense : nil)            // If they are not friends, blurr it or if they
                        .opacity((user.isNearby ?? false) ? 0: 1)
                    
                    tabViewForPlacementsInChart()
                        .Redacted(reason: !(user.areFriends ?? false ) ? .blurredLessIntense :  nil )
                        .opacity((user.isNearby ?? false  == true) ? 1: 0 )
                    
                    /*
                    Image(systemName: "lock.fill") // as long as the natal chart is nil or this is purposely locked
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .opacity(user.natal_chart == nil  && (/**not loading */  user.areFriends != nil ) ? 1: 0 )
                        .offset(y: -25)
                    */
                }
                .onTapGesture {
                    
                    if user.natal_chart == nil {
                        attempts+=1
                        attemptsToggle.toggle()
                    }
                }
                    
                
              
                ZStack{
                    
                    tabViewForProgressCircles()
                        .Redacted(reason: user.synastry_classification == nil ? .blurred : nil)
                    
                    
                    Button {
                        attempts+=1
                        attemptsToggle.toggle()
                    } label: {
                        
                        Image(systemName: "lock.fill") // as long as the natal chart is nil or this is purposely locked
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .opacity(user.synastry_classification == nil  && (/**not loading */  user.areFriends != nil ) ? 1: 0 )
                            .modifier(Shake(animatableData: CGFloat(attempts)))

                    }
                   
                   
                        
                }
                .SPIndicator(isPresent: $attemptsToggle, title: "Private", message: "You aren't friends", duration: 2.0, presentSide: .top, dismissByDrag: true, preset: .error, haptic: .error, layout: SPIndicatorLayout.init(iconSize: CGSize(width: 15, height: 15), margins: UIEdgeInsets.init(top: CGFloat(0), left: CGFloat(30), bottom: CGFloat(0), right: CGFloat(0))))

                    
            
                
                                    
                
              
                
                
                
                     
                     
                }
            // Turns down the brightness when the menu pops up
            .brightness(showActionForUser ? -0.5: 0)
            .brightness(showNegativeActionForUser ? -0.5: 0)
            
            
            
            PositiveActionOnUserMenu(user: $user)
                .opacity(showActionForUser ? 1: 0)
            
            
             /*
            NegativeActionOnUserMenu(user: user, account: account)
                .opacity(showNegativeActionForUser ? 1: 0 )
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.deletedCustomUserNatalChart)) { output in
                    
                    withAnimation {
                        
                        showActionForUser = false
                        showNegativeActionForUser = false
                     
                        
                    }
                    
                    
                }
            
            */
            
          
            
           // ConfettiCannon(counter: $counterForConfetti, num: 250, confettis: [.text("😉")], rainHeight: 700/*, closingAngle: .degrees(140)*/)
                //   .offset(y: 30)
            

        }
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .onAppear(perform: {
            
                withAnimation {
                    
                    showProfilePopup = true
              
            }
            
            
        
            
       
        })
        .onTapGesture {
            withAnimation {
                // Dismiss the action view
                showActionForUser = false
                showNegativeActionForUser = false
                //placementToDisplay = nil
            }
        }
        .onChange(of: user._synastryScore) { newValue in
            
        
                withAnimation(.easeInOut(duration: 3)) {
                    synastryscore = RingProgress.percent(newValue)
                }
            
        }
        
        .onChange(of: user._chemistryScore) { newValue in
            
                withAnimation(.easeInOut(duration: 3)) {
                    chemistry = RingProgress.percent(newValue)
                }
            
        }
        
        .onChange(of: user._sexScore) { newValue in
            
                withAnimation(.easeInOut(duration: 3)) {
                    sex = RingProgress.percent(newValue)
                }
            
        }
        
        .onChange(of: user._loveScore) { newValue in
            
                withAnimation(.easeInOut(duration: 3)) {
                    love = RingProgress.percent(newValue)
                }
            
        }
            
        .onChange(of: user.winkedAtMe, perform: { winkedAtMe in
            
           
            
            if (winkedAtMe ?? false)  && (user.winkedTo ?? false)  {
                    doShowConfetti()            }
            
            if winkedAtMe ?? false && (user.winkedTo ?? false) == false {
                    doShowWinkConfetti()
            }
        })
            
            
        .onChange(of: placementToDisplay) { newValue in
            
           
            // This is called when you click on a placement .. not when you scroll through them.
                exitInfoOnPlacement = false
            if let _ = placementToDisplay { showPlacements = true }
            
            /*
            print("***CHANGED PLACEMENT TO DISPLAY \(newValue)")
            if let placement = placementToDisplay{
                viewModelForPlanetView.findPeople(with: placement)
            }
            */
        }
            /*
        .onChange(of: user.winkedAtMe) { didWinkAtMe in
            
            if didWinkAtMe ?? false  { withAnimation {
                
                AmareApp().delay(3) {
                    
                    counterForConfetti += 1
                }
                
            } } else {
                
                withAnimation {
                    counterForConfetti = 0
                }
            }
        }
        .onChange(of: user.winkedTo) { iWinkedTo in
            if iWinkedTo ?? false  && user.winkedAtMe ?? false  {
                withAnimation {
                    
                    AmareApp().delay(3) {
                        
                        counterForConfetti += 1
                    }
                    
                    
                }
            }
        }
             */
        .onChange(of: selectedBody) { body in
             
            print("***JUST changed selected body ... it is \(body)")
            // works on first click
            
        }
        
        /*
        .onChange(of: user, perform: { user_selected in
            
            print("The user selected is \(user_selected)")
            guard let me = Auth.auth().currentUser?.uid , let them = user_selected?.id else  {
                
                print("Could not get me: \(Auth.auth().currentUser?.uid) or them: \(user_selected?.id) ")
                
                return
            }
            
            // get the natal chart
            
            account.getNatalChart(from: them, pathTousers: "users") { err, natalChart in
                print("The natal chart we get from profile has error \(err) ith chart \(natalChart)")
                
                withAnimation {
                    chart = natalChart
                }
            }
            
            
            print("LISTENING FOR WINKS")
            account.db?.collection("winks").document(me).collection("people_who_winked").document(them).addSnapshotListener({ snapshot, error in
                
                print("*** THe snapshot is \(snapshot) with error \(error)")
                
                if snapshot?.exists ?? false {
                    withAnimation {
                        
                        hasWinked = true
                        counterForConfetti += 1
                    }
                   
                } else {
                    withAnimation {
                        hasWinked = false
                    }
                }
            })
        })
         */
            
            
        /*
            
            if user.natal_chart?.planets.count ?? 0 > 0 {
                
                
                
                
                // Showing the other user's planetary placements 
                TabView(selection: $selectedBody){
                    
             
                        
                    ForEach(user.natal_chart?.planets ?? [] ){ planet in
                            
                          
                                
                                VTabView{
                                    
                                  
                                 
                                   
                                    MoreInfoOnPlanet(planet: planet, exit: $exitInfoOnPlacement)
                                       
                                    
                                    
                                        .onAppear(perform: {
                                            
                                            
                                        print("***CALLED IN FOREACH ... the planet is \(planet)")
                                            // viewModelForPlanetView.findPeople(with: planet)
                                        })
                                      //  .opacity(exitInfoOnPlacement ? 0: 1)
                                        

                                            .padding()
                                            
                                     
                            
                                        
                                    MoreInfoOnPlanet(planet: Account.shared.data?.natal_chart?.planets.get(planet: planet.name), exit: $exitInfoOnPlacement)
                                                                              //  .opacity(exitInfoOnPlacement ? 0: 1)
                                           
                                            .padding()
                        
                                           
                                
                                        
                                    
                                    
                                    
                                   
                                }
                                .tag(planet.name.number())
                                .tabViewStyle(.page)
                               
                              
                             
                             
                              
                               
                                
                            
                         
                                
                                
                            
                            
                            
                            
                            
                            
                               
                            
                           
                                
                        }
                        
                   
                    
                }
                //.tabViewStyle(.page(indexDisplayMode: .always))
                .tabViewStyle(.page)
                .opacity(placementToDisplay == nil ? 0 : 1 )
                .opacity(exitInfoOnPlacement ? 0: 1)
                .animation(.easeInOut)
              
                .onDisappear {
                    //viewModelForPlanetView.stopLookingForPeopleWithAspect()
                }
              
                //.border(.orange)
            }
            
            */
          
           
    
        }
        // Alert View / SP Indicator 
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.exitPlacements), perform: { _ in
            showPlacements = false
        })
        .onAppear(perform: {
            
        })
        
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.gotWinkedAt), perform: { _ in
            
            doShowWinkConfetti()
            //doShowConfetti()
        })
        
        .fullScreenCover(isPresented: $showPlacements ) {
            
            if user.natal_chart?.planets.count ?? 0 > 0 {
                
                
                
                
                // Showing the other user's planetary placements
                TabView(selection: $selectedBody){
                    
             
                        
                    ForEach(user.natal_chart?.planets ?? [] ){ planet in
                            
                          
                                
                                VTabView{
                                    
                                  
                                 
                                   
                                    MoreInfoOnPlanet(planet: planet, exit: $showPlacements)
                                       
                                    
                                    
                                        .onAppear(perform: {
                                            
                                            
                                        print("***CALLED IN FOREACH ... the planet is \(planet)")
                                            // viewModelForPlanetView.findPeople(with: planet)
                                        })
                                      //  .opacity(exitInfoOnPlacement ? 0: 1)
                                        

                                            .padding()
                                            
                                     
                            
                                        
                                    MoreInfoOnPlanet(planet: Account.shared.data?.natal_chart?.planets.get(planet: planet.name), exit: $showPlacements)
                                                                              //  .opacity(exitInfoOnPlacement ? 0: 1)
                                           
                                            .padding()
                        
                                           
                                
                                        
                                    
                                    
                                    
                                   
                                }
                                .tag(planet.name.number())
                                .tabViewStyle(.page)
                               
                              
                             
                             
                              
                               
                                
                            
                         
                                
                                
                            
                            
                            
                            
                            
                            
                               
                            
                           
                                
                        }
                        
                   
                    
                }
                //.tabViewStyle(.page(indexDisplayMode: .always))
                .tabViewStyle(.page)
                .opacity(placementToDisplay == nil ? 0 : 1 )
                .opacity(exitInfoOnPlacement ? 0: 1)
                .animation(.easeInOut)
              
                .onDisappear {
                    //viewModelForPlanetView.stopLookingForPeopleWithAspect()
                }
              
                //.border(.orange)
            }
        }
    }
    
  
    /// Button for the profile image view.
    /// TODO: should show rest of the users images/media
    func profileImageView() -> some View  {
        
        return Button {
            
            //TODO: Show rest of images
            print("Tapped profile to view images. TODO: Show profile image ")
            // remove later
           // SPConfetti.startAnimating(.centerWidthToDown, particles: [.heart, .triangle, .arc])
           
           // showConfetti.toggle()
            
          
            
        } label: {
            
            
            
          
            URLImage(URL(string: user.profile_image_url ?? "https://findamare.com")!) { progress in
                
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    // .frame(width: 100, height: 100)
                     .shadow(radius: 15)
                     .frame(width: 150, height: 150)
                     .redacted(reason: .placeholder)
                     .blur(radius: condition ? 0.0 : 4.0)
                     //.scaleEffect(condition ? 0.9 : 1.0)
     
                     .animation(Animation
                                .easeInOut(duration: 3)
                                 .repeatForever(autoreverses: true))
                     .onAppear { condition = true }
                
                     
                
            }
            
        failure: {  error,retry in
            
            Image(systemName: "person.fill.questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                // .frame(width: 100, height: 100)
                 .shadow(radius: 15)
                 .frame(width: 150, height: 150)
                 .redacted(reason: user.profile_image_url == nil ? .placeholder : [])
                 .blur(radius: condition2 ? 4.0 : 0.0)
                 //.scaleEffect(condition2 ? 0.8 : 1.0)
                 //.animation(Animation
                 //           .easeInOut(duration: 3)
                  //           .repeatForever(autoreverses: true))
                 .onAppear {  withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
                     condition2 = true
                 }  }
        }
        
        
        content: { image, info in
                
            
            ZStack{
                
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    // .frame(width: 100, height: 100)
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .frame(width: 150, height: 150)
                     .opacity(user.profile_image_url != nil ? 1: 0)
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    // .frame(width: 100, height: 100)
                     .shadow(radius: 15)
                     .frame(width: 150, height: 150)
                     .redacted(reason: .placeholder)
                     .blur(radius: condition ? 0.0 : 4.0)
                     //.scaleEffect(condition ? 0.9 : 1.0)
     
                     .animation(Animation
                                .easeInOut(duration: 1)
                                .repeatForever(autoreverses: true))
                     .opacity(user.profile_image_url == nil ? 1: 0)
                     .onAppear { condition = true }
            }
            .confetti(isPresented: $showConfetti, animation: .fullWidthToDown, particles: [.arc, .heart, .star], duration: 3)
            .confettiParticle(\.velocity, 300)
            .confettiParticle(\.birthRate, 150)
          //  .confettiParticle(\.velocityRange, 100)
            //.confettiParticle(\.spin, 5)
        }
        

        

    }
        
    }
    
    /// Name of the user
    func nameView() -> some View {
       
        ZStack {
            
            Text("\(user.name ?? "Name Not Found")")
                        .font(.largeTitle)
                         .bold()
                         .frame(maxWidth : .infinity, alignment: .center)
                        //.padding(.top)
                        .foregroundColor(Color.primary.opacity(0.4))
                        .modifier(FadeModifier(control: showProfilePopup))
                        .redacted(reason: user.name == nil ? .placeholder : [])
                        .blur(radius: condition ? 0.0 : 4.0)
                        //.scaleEffect(condition ? 0.9 : 1.0)
        
                        .animation(Animation
                                   .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true))
                        .onAppear { condition = true }
                        .opacity(user.name == nil ? 1: 0)
            
            Text("\(user.name ?? "Name Not Found")")
                        .font(.largeTitle)
                         .bold()
                         .frame(maxWidth : .infinity, alignment: .center)
                        //.padding(.top)
                        .foregroundColor(Color.primary.opacity(0.4))
                        .modifier(FadeModifier(control: showProfilePopup))
                        .opacity(user.name == nil ? 0: 1)
                        //.scaleEffect(condition ? 0.9 : 1.0)
        
                       
        }
       
                  
                    
    }
    
    /// Soulmate, friend, enemy etc
    func classificationView() -> some View {
        
        // Classification
        return Text( "\(user.synastry_classification ?? "Friends")")
                        .font(.callout)
                        .frame(maxWidth : .infinity, alignment: .center)
                        .foregroundColor(Color.primary.opacity(0.4))
                        .padding(.bottom)
                        .modifier(FadeModifier(control: showProfilePopup))
                        .redacted(reason: .privacy)
                       // .shimmering(duration: 5, bounce: true)
    }
    
    
    
    /// Button for showing menu for actions on this user
    func plusMenuButtonView() -> some View {
        
        return ZStack{
            
            Button {
                withAnimation {
                    showActionForUser = true
                }
               
            } label: {
                
                ZStack{
                    
                    
                    Image(systemName: "plus.circle")
                        .modifier(ConvexGlassView())
                       /*  .opacity(showActionForUser ? 1: 0 ) */
                     
                    
                    
                    Image(systemName: "plus.circle.fill")
                          .modifier(ConcaveGlassView())
                          /*.opacity(showActionForUser == false ? 1 : 0) */
                     
                }
                
               
                
                
                
            }.offset(x: 10, y: -35.0)
            
           
        }
       // .opacity(user.isReal ?? true == true  ? 1 : 0)
    }
    
    func minusMenuButtonView() -> some View {
        //For the negative actions
            ZStack{
                
                Button {
                    withAnimation {
                       
                        showNegativeActionForUser = true
                    }
                   
                } label: {
                    
                    ZStack{
                        
                        
                        Image(systemName: "minus.circle")
                            .modifier(ConvexGlassView())
                           
                         
                        
                        
                        Image(systemName: "minus.circle.fill")
                              .modifier(ConcaveGlassView())
                              
                         
                    }
                    
                   
                    
                    
                    
                }.offset(x: 10, y: -35.0)
                
               
            }
            .opacity(0)
        
            //.opacity(user.isReal ?? true == false  ? 1 : 0)
    }
    
    /// View for the latin phrase that describes relationshio
    func latinPhraseView() -> some View {
        Text( "\(user.synastry_latin_phrase ?? "Amor Vincit Omnia")")
                            .font(.callout)
                            .frame(maxWidth : .infinity, alignment: .center)
                            .foregroundColor(Color.primary.opacity(0.4))
                            .modifier(FadeModifier(control: showProfilePopup))
                            .opacity(user.winkedAtMe ?? false ? 0: 1)
                            .multilineTextAlignment(.center)
    }
    
    func someoneWinkedAtYouView() -> some View {
        ZStack{
            
            Button {
                
                
                withAnimation {
                    
                    showActionForUser = true
                }
            } label: {
                
               
                    VStack{
                        Text("😉").padding(.bottom, 1)
                            .animation(.easeInOut)
                        Text("\(user.name ?? sampleNames.randomElement()!) winked at you!")
                            .animation(.easeInOut)
                    }
                
                
                
            }
            .opacity(user.winkedAtMe ?? false  ? 1: 0)
            .animation(.easeInOut, value: user.winkedAtMe)
            .zIndex(1)
            
          //  ConfettiCannon(counter: $counterForConfetti)
          //  ConfettiCannon(counter: $counterForConfetti, num: 150, confettis: [.text("😉")], openingAngle: .degrees(0), closingAngle: .degrees(360), radius: 200)
            .confetti(isPresented: $showWinkConfetti, animation: .fullWidthToDown, particles: [.custom(UIImage(named: "ProfileView/wink")!)], duration: 3)
            .confettiParticle(\.velocity, 300)
            .confettiParticle(\.birthRate, 150)
            
            
           
            

            
            
        }
    }
    
    func tabViewForPlacementsInChart() -> some View {
        
        
        TabView{
            
            HStack{
                
           
                var sun = user.natal_chart?.planets.get(planet: .Sun)
        
                Button {
                    placementToDisplay = sun
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView( planet: sun, size: 20).padding(.trailing)
                }

                  
                
                let moon = user.natal_chart?.planets.get(planet: .Moon)
                
                Button{
                    placementToDisplay = moon
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Moon), size: 20).padding(.trailing)
                }
                
               
                
                let asc = user.natal_chart?.angles.get(planet: .asc)
              
                //TODO: Do something for people who don't know birth times
                
                
                MainPlacementView_Angle(angle: user.natal_chart?.angles.get(planet: .asc), size: 20).padding(.trailing)
                
                
             
            }
                
            HStack{
                
                let mercury = user.natal_chart?.planets.get(planet: .Mercury)
                
                Button{
                    
                    placementToDisplay = mercury
                    selectedBody = placementToDisplay?.name.number() ?? 12
                    
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Mercury), size: 20).padding(.trailing)
                    
                }
                
                
                
                let venus = user.natal_chart?.planets.get(planet: .Venus)
                
                Button{
                    
                    placementToDisplay = venus
                    selectedBody = placementToDisplay?.name.number() ?? 12
                    
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Venus), size: 20).padding(.trailing)
                }
                
                
                let mars = user.natal_chart?.planets.get(planet: .Mars)
                
        
                Button{
                    
                    placementToDisplay = mars
                    selectedBody = placementToDisplay?.name.number() ?? 12
                    
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Mars), size: 20).padding(.trailing)
                }
               
            }
                
            HStack{
                
                let jupiter = user.natal_chart?.planets.get(planet: .Jupiter)
                let saturn = user.natal_chart?.planets.get(planet: .Saturn)
                let uranus = user.natal_chart?.planets.get(planet: .Uranus)
                
                
                Button{
                    placementToDisplay = jupiter
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Jupiter), size: 20).padding(.trailing)
                }
              
                
                Button{
                    placementToDisplay = saturn
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Saturn), size: 20).padding(.trailing)
                }
                
                Button{
                    placementToDisplay = uranus
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Uranus), size: 20).padding(.trailing)
                }
              
                
               
                
            
               
            }
                
               
            HStack{
                
                let neptune = user.natal_chart?.planets.get(planet: .Neptune)
                let pluto = user.natal_chart?.planets.get(planet: .Pluto)
                
                Button{
                    
                    placementToDisplay = neptune
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Neptune), size: 20).padding(.trailing)
                }
                
                Button{
                    
                    placementToDisplay = pluto
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .Pluto), size: 20).padding(.trailing)
                }
              
               
                
                
            }
            
            HStack{
                
                let northNode = user.natal_chart?.planets.get(planet: .NorthNode)
                let southNode = user.natal_chart?.planets.get(planet: .SouthNode)
                
                
                Button{
                     placementToDisplay = northNode
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .NorthNode), size: 20).padding(.trailing)
                }
                
                Button{
                     placementToDisplay = southNode
                    selectedBody = placementToDisplay?.name.number() ?? 12
                } label: {
                    MainPlacementView(planet: user.natal_chart?.planets.get(planet: .SouthNode), size: 20).padding(.trailing)
                }
        
                
               
              
            }
            
            HStack{
                
                MainPlacementView_Angle(angle: user.natal_chart?.angles.get(planet: .ic), size: 20).padding(.trailing)
                
                MainPlacementView_Angle(angle: user.natal_chart?.angles.get(planet: .mc), size: 20).padding(.trailing)
                
                MainPlacementView_Angle(angle: user.natal_chart?.angles.get(planet: .desc), size: 20).padding(.trailing)
            }

                
            
                
                
                
                
            
           
        }
     
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .frame(width: .infinity, height: 150)
        .tabViewStyle(.page)
        .padding(.top, -50)
       
    }
    
    func tabViewForProgressCircles() -> some View {
        // Ring styles for progress circles
        let o_ringstyle: RingStyle = .init(
            color: .color(.gray),
            strokeStyle: .init(lineWidth: 10)
        )
        
      
       
            
        
        
        return  TabView(selection: $tagSelected) {
            
                
            
                        
              // Synastry Score
         
                        ProgressRing(progress: $synastryscore, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "synastry")) { percent in
                            
                            
                            let pcent = Int(round(percent*100))
                            
                            VStack{
                                
                                    
                                
                                Text("\(pcent)")
                                                .font(.title)
                                                .bold()
                            }
                            
                            
                        }
                        .animation(.easeInOut(duration: 5))
                            .frame(width: 150, height: 150)
                            //.offset(y: 35)
                            
                            .onAppear {
                                
                                AmareApp().delay(3) {
                                    
                                    withAnimation(.easeInOut(duration: 3)) {
                                        synastryscore = RingProgress.percent(Double.random(in: 0...1))

                                    }

                                }
                            }.tag(1)
               
           
       
                            
                          
                            
            
                          
                        
                        
         // Chemistry, Love, Sex
            HStack{
                
                
                        ProgressRing(progress: $chemistry, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "chemistry")) { percent in
                            
                            
                            let pcent = Int(round(percent*100))
                            
                            VStack{
                                
                                Text("Chemistry")
                                    .font(.subheadline)
                                    
                                    
                                
                                Text("\(pcent)")
                                                .font(.title)
                                                .bold()
                            }
                            
                            
                        }
                            .frame(width: 115, height: 115)
                            .animation(.easeInOut(duration: 5))
                           // .offset(y: 10)
                            .onAppear {
                                
                                withAnimation(.easeInOut(duration: 15)) {
                                    chemistry = RingProgress.percent(Double.random(in: 0...1))

                                }
                            }
                            
                        
                        
                        ProgressRing(progress: $love, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "love")) { percent in
                            
                            
                            let pcent = Int(round(percent*100))
                            
                            VStack{
                                
                                Text("Love")
                                    .font(.subheadline)
                                    
                                
                                Text("\(pcent)")
                                                .font(.title)
                                                .bold()
                            }
                            
                            
                        }
                            .frame(width: 115, height: 115)
                            .animation(.easeInOut(duration: 5))
                          //  .offset(y: 10)
                            .onAppear {
                                
                                withAnimation(.easeInOut(duration: 3)) {
                                    love = RingProgress.percent(Double.random(in: 0...1))

                                }
                            }
                           
                        
                        ProgressRing(progress: $sex, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "sex")) { percent in
                            
                            
                            let pcent = Int(round(percent*100))
                            
                            VStack{
                                
                                Text("Sex")
                                    .font(.subheadline)
                                    
                                
                                Text("\(pcent)")
                                                .font(.title)
                                                .bold()
                            }
                            
                            
                        }
                            .frame(width: 115, height: 115)
                            .animation(.easeInOut(duration: 5))
                          //  .offset(y: 10)
                            .onAppear {
                                
                                withAnimation(.easeInOut(duration: 3)) {
                                    sex = RingProgress.percent(Double.random(in: 0...1))

                                }
                            }
                            
            }.tag(2)
                    
            Button(action: {
                print("Tapped natal chart")
            }) {
                
                SmallNatalChartView()
                    .makeSmall(with: user.natal_chart)
                
            }.tag(3)
        
               
                    
                }
                
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .frame(width: .infinity, height: 150)
                .tabViewStyle(.page)
            
                
               
    }
    
   
    
    // Only show this if we've both winked at each other and check user defaults to make sure that we haven't done this recently. This does it for you.
    func doShowConfetti()  {
        
        showConfetti.toggle()
        
            /*
       var didShow =  UserDefaults.standard.bool(forKey: "showConfetti-\(user.id ?? "no id")")
        
        if !didShow{
            
            showConfetti.toggle()
            UserDefaults.standard.set(true, forKey: "showConfetti-\(user.id ?? "no id")")
        }
             */
        
    }
    
    func doShowWinkConfetti()  {
        
        showWinkConfetti.toggle()
        
        /*
       var didShow =  UserDefaults.standard.bool(forKey: "showWinkConfetti-\(user.id ?? "no id")")
        
        if !didShow{
            
            showWinkConfetti.toggle()
            UserDefaults.standard.set(true, forKey: "showWinkConfetti-\(user.id ?? "no id")")
        }
        */
        
    }

    func ringStyleFor(progress: String ) -> RingStyle {
        
        var color: Color = .green
        
        var number = 0.0
    
        switch progress {
        case "synastry":
            number = synastryscore.asDouble ?? 0
        case "chemistry":
            number = chemistry.asDouble ?? 0
        case "sex":
            number = sex.asDouble ?? 0
        case "love":
            number = love.asDouble ?? 0
        default:
            number = 0
        }
        
         number = number*100
        
        if number <= 25.0 { color = .red }
        if number > 25.0 {color = .orange}
        if number >= 40.0  {color = .yellow}
        if number >= 60.0 { color = .green }
        if number >= 85.0 {color = .blue}
        
                
        
       return  .init(
                        color: .color(color),
                        strokeStyle: .init(lineWidth: 5),
                        padding: 2.5)
    }
}



struct ProfilePopup_Previews: PreviewProvider {
    static var previews: some View {
        
        
        let a = AmareUser(id: "23", name: "Micheal", hometown: nil, birthday: nil, known_time: true, residence: nil, profile_image_url: "https://twitter.com", images: [], sex: .male, orientation: nil, natal_chart: nil, username: "micheal", isReal: true, isNotable: true, _synastryScore: 0)
        
        ProfilePopup( user: .constant(a)).preferredColorScheme(.dark)
        
       
    }
}



public enum RedactionReason {
  case placeholder
  case confidential
  case blurred
  case blurredLessIntense
}


struct Placeholder: ViewModifier {
  func body(content: Content) -> some View {
    content
      .accessibility(label: Text("Placeholder"))
      .opacity(0)
      .overlay(
        RoundedRectangle(cornerRadius: 2)
          .fill(Color.black.opacity(0.1))
          .padding(.vertical, 4.5)
    )
  }
}

struct Confidential: ViewModifier {
  func body(content: Content) -> some View {
    content
      .accessibility(label: Text("Confidential"))
      .overlay(Color.black)
    
  }
}

struct Blurred: ViewModifier {
  func body(content: Content) -> some View {
    content
      .accessibility(label: Text("Blurred"))
      .blur(radius: 10)
  }
    
    
}


struct BlurredLessIntense: ViewModifier {
  func body(content: Content) -> some View {
    content
      .accessibility(label: Text("Blurred"))
      .blur(radius: 4)
  }
    
    
}


struct Redactable: ViewModifier {
  let reason: RedactionReason?

  @ViewBuilder
  func body(content: Content) -> some View {
    switch reason {
    case .placeholder:
      content
        .modifier(Placeholder())
    case .confidential:
      content
        .modifier(Confidential())
    case .blurred:
      content
        .modifier(Blurred())
    case .blurredLessIntense:
        content
            .modifier(BlurredLessIntense())
    case nil:
      content
    }
  }
}

extension View {
  func Redacted(reason: RedactionReason?) -> some View {
    modifier(Redactable(reason: reason))
  }
}


struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

