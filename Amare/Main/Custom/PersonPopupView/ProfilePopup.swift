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

// Some random data to use as mock
var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],

"https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]

var colors: [Color] = [.gray, .green, .blue, .red, .orange]


struct ProfilePopup: View {
    
    ///*@Binding*/ var user: AmareUser?
    //@State  var account: Account
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    @State var showProfilePopup: Bool = false
    
    
    @State var showActionForUser: Bool = false
    @State var showNegativeActionForUser: Bool = false
    @State var showBottomPopup: Bool = false
    @State var infoToShow:String?
    @State var chart: NatalChart?
    
    // Properties for the profile pop up
    @State var synastryscore = RingProgress.percent(0)
    @State var chemistry = RingProgress.percent(0)
    @State var love = RingProgress.percent(0)
    @State var sex = RingProgress.percent(0)
    
    // Indicates whether the user has winked at the user
    @State var hasWinked: Bool = false // set to false for prod
    
    @State var counterForConfetti: Int = 0
    
    
    var body: some View {
       
       
        
        ZStack{
            
            
            
            
            VStack{
                
                
                ZStack{
                     
                    profileImageView()
                    
                  

                    
                   
                    
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
                
                
                
                ZStack{
                    
                    // Latin Phrase
                    latinPhraseView()
                    
                                        
                    
                    //TODO: Make this area more tappable
                    
                    someoneWinkedAtYouView()

                    
                    
                }
                
               
                  
                tabViewForPlacementsInChart()
                                  
                
                
              
                    
                tabViewForProgressCircles()
                                    
                
              
                
                
                
                     
                     
                }
            // Turns down the brightness when the menu pops up
            .brightness(showActionForUser ? -0.5: 0)
            .brightness(showNegativeActionForUser ? -0.5: 0)
            
            
            /*
            PositiveActionOnUserMenu(user: user, account: account, canWinkBack: $hasWinked)
                .opacity(showActionForUser ? 1: 0)
            
            
            NegativeActionOnUserMenu(user: user, account: account)
                .opacity(showNegativeActionForUser ? 1: 0 )
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.deletedCustomUserNatalChart)) { output in
                    
                    withAnimation {
                        
                        showActionForUser = false
                        showNegativeActionForUser = false
                     
                        
                    }
                    
                    
                }
            
            */
            
            ConfettiCannon(counter: $counterForConfetti, num: 250, confettis: [.text("😉")], rainHeight: 700/*, closingAngle: .degrees(140)*/)
                .offset(y: 30)
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .onAppear(perform: {
            
                withAnimation {
                    viewModel.subscribeToUserDataChanges()
                    showProfilePopup = true
              
            }
            
            
        
            
       
        })
        .onTapGesture {
            withAnimation {
                // Dismiss the action view
                showActionForUser = false
                showNegativeActionForUser = false
            }
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
        
          
        
        
    }
    
  
    /// Button for the profile image view.
    /// TODO: should show rest of the users images/media
    func profileImageView() -> some View  {
        
        return Button {
            
            //TODO: Show rest of images
            print("Tapped profile to view images. TODO: Show profile image ")
            
        } label: {
            
        
            
            URLImage(URL(string: viewModel.userData?.profile_image_url ?? peopleImages.randomElement()!)!) { image in
                
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    // .frame(width: 100, height: 100)
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .frame(width: 150, height: 150)
            }
            
            
            
        }
    }
    
    /// Name of the user
    func nameView() -> some View {
       
        Text("\(viewModel.userData?.name ?? sampleNames.randomElement()!)")
                    .font(.largeTitle)
                     .bold()
                     .frame(maxWidth : .infinity, alignment: .center)
                    //.padding(.top)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .modifier(FadeModifier(control: showProfilePopup))
    }
    
    /// Soulmate, friend, enemy etc
    func classificationView() -> some View {
        
        // Classification
    return Text( "\(sampleClassifications.randomElement()!)")
                        .font(.callout)
                        .frame(maxWidth : .infinity, alignment: .center)
                        .foregroundColor(Color.primary.opacity(0.4))
                        .padding(.bottom)
                        .modifier(FadeModifier(control: showProfilePopup))
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
        .opacity(viewModel.userData?.isReal ?? true == true  ? 1 : 0)
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
            .opacity(viewModel.userData?.isReal ?? true == false  ? 1 : 0)
    }
    
    /// View for the latin phrase that describes relationshio
    func latinPhraseView() -> some View {
        Text("\(sampleLatinPhrases.randomElement()!)")
                            .font(.callout)
                            .frame(maxWidth : .infinity, alignment: .center)
                            .foregroundColor(Color.primary.opacity(0.4))
                            .modifier(FadeModifier(control: showProfilePopup))
                            .opacity(hasWinked ? 0: 1)
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
                        Text("\(viewModel.userData?.name ?? sampleNames.randomElement()!) winked at you!")
                    }
                
                
                
            }.opacity(hasWinked ? 1: 0 )
            .zIndex(1)
            
          //  ConfettiCannon(counter: $counterForConfetti)
           /* ConfettiCannon(counter: $counterForConfetti, num: 150, confettis: [.text("😉")], openingAngle: .degrees(0), closingAngle: .degrees(360), radius: 200)
            */
            
            
            

            
            
        }
    }
    
    func tabViewForPlacementsInChart() -> some View {
        TabView{
            
            HStack{
                
           
                
                MainPlacementView( planet: chart?.planets.get(planet: .Sun), size: 20).padding(.trailing)
                    
                
                MainPlacementView(planet: chart?.planets.get(planet: .Moon), size: 20).padding(.trailing)
                
              
                //TODO: Do something for people who don't know birth times
            MainPlacementView_Angle(angle: chart?.angles.get(planet: .asc), size: 20).padding(.trailing)
                
                
             
            }
                
            HStack{
                MainPlacementView(planet: chart?.planets.get(planet: .Mercury), size: 20).padding(.trailing)
                
                MainPlacementView(planet: chart?.planets.get(planet: .Venus), size: 20).padding(.trailing)
                
        
                MainPlacementView(planet: chart?.planets.get(planet: .Mars), size: 20).padding(.trailing)
            }
                
            HStack{
                
                MainPlacementView(planet: chart?.planets.get(planet: .Jupiter), size: 20).padding(.trailing)
                
                MainPlacementView(planet: chart?.planets.get(planet: .Saturn), size: 20).padding(.trailing)
                
            
                MainPlacementView(planet: chart?.planets.get(planet: .Uranus), size: 20).padding(.trailing)
            }
                
               
            HStack{
                MainPlacementView(planet: chart?.planets.get(planet: .Neptune), size: 20).padding(.trailing)
                MainPlacementView(planet: chart?.planets.get(planet: .Pluto), size: 20).padding(.trailing)
                
                
            }
            
            HStack{
                
                
                MainPlacementView(planet: chart?.planets.get(planet: .NorthNode), size: 20).padding(.trailing)
                
               
                MainPlacementView(planet: chart?.planets.get(planet: .SouthNode), size: 20).padding(.trailing)
            }
            
            HStack{
                
                MainPlacementView_Angle(angle: chart?.angles.get(planet: .ic), size: 20).padding(.trailing)
                
                MainPlacementView_Angle(angle: chart?.angles.get(planet: .mc), size: 20).padding(.trailing)
                
                MainPlacementView_Angle(angle: chart?.angles.get(planet: .desc), size: 20).padding(.trailing)
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
        
      
       
            
        
        
       return  TabView {
            
                
            
                        
              // Synastry Score
                        ProgressRing(progress: $synastryscore, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "synastry")) { percent in
                            
                            
                            let pcent = Int(round(percent*100))
                            
                            VStack{
                                
                                    
                                
                                Text("\(pcent)")
                                                .font(.title)
                                                .bold()
                            }
                            
                            
                        }//.animation(.easeInOut(duration: 5))
                            .frame(width: 150, height: 150)
                            .onAppear {
                                
                                
                                AmareApp().delay(1) {
                                    
                        
                                    
                                    withAnimation(.easeInOut(duration: 3)) {
                                        synastryscore = RingProgress.percent(Double.random(in: 0...1))
                                        
                                    }
                            
                                    
                                }
                               
                            }
                            
            
                          
                        
                        
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
                            .onAppear {
                                
                                withAnimation(.easeInOut(duration: 3)) {
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
                            .onAppear {
                                
                                withAnimation(.easeInOut(duration: 3)) {
                                    sex = RingProgress.percent(Double.random(in: 0...1))

                                }
                            }
                            
            }
                    
            Button(action: {
                print("Tapped natal chart")
            }) {
                
                SmallNatalChartView()
                    .makeSmall(with: chart)
                
            }
        
               
                    
                }
                
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .frame(width: .infinity, height: 150)
                .tabViewStyle(.page)
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


/*
struct ProfilePopup_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePopup( account: Account()).preferredColorScheme(.dark)
    }
}
*/

