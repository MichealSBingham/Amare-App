//
//  MiniAspectView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/7/23.
//

import SwiftUI
import LoremSwiftum
import Shimmer
import FirebaseAuth
struct MiniAspectView: View {
    var interpretation: String?
    var firstBody: Body?
    var secondBody: Body?
    var orb: Double?
    var name: String?
    var aspectType: AspectType?
    var belongsToUserID:  String
    
    @StateObject var model: MiniAspectViewModel = MiniAspectViewModel()
    
    
    var numSentences: Int = 0
   @State  var unlockAlert: Bool = false
    
    var body: some View {
        
        ZStack{
            
           bodyImages()
                .alert(isPresented: $model.notEnough) {
                            Alert(
                                title: Text("Not Enough Stars 🌟"),
                                message: Text("Sorry, you don't have enough stars. 😢\n\nYou can earn more stars by:\n1. Adding friends\n2. Engaging with the app"),
                                primaryButton: .default(Text("NVM")),
                                secondaryButton: .default(Text("I'll share!")) {
                                    // Code to open the native share sheet
                                    shareApp()
                                }
                            )
                        }
            
           
            
            VStack{
               
                  
                   // .padding()
                
                if numSentences == 0 {
                    Aspectname()
                    ScrollView{
                        
                    
                    (Text(interpretation ?? Lorem.sentences(3)) )
                            .lineSpacing(10)
                            .lineLimit(100)
                            .truncationMode(.tail)
                        .redacted(reason: interpretation == nil ? .placeholder : [])
                        //.shimmering()
                        .multilineTextAlignment(.center)
                        .padding()
                        
                    
                    
                }
                    .frame(height: 300)
                    .padding()
                } else{
                    (Text(interpretation?.firstNSentences(numSentences) ?? Lorem.sentences(3)) )
                            .lineSpacing(10)
                            .lineLimit(100)
                            .truncationMode(.tail)
                        .redacted(reason: interpretation == nil ? .placeholder : [])
                        //.shimmering()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                }
                    
                
                
               icons()
                
                if numSentences == 0 {
                    OrbLabel()
                }
                
                
            }
            .blur(radius: interpretation == nil ? 2: 0)
            
            Button{
                print("Should show alert for mini aspect unlocking")
                unlockAlert = true
            } label: {
                ZStack{
                    Text("Unlock this piece of knowledge for 1 star.")
                        .font(.headline.bold())
                        //.fontWeight(.black)
                    LockIconView()
                        .font(.system(size: 50))
                        .foregroundColor(.amare)
                        .rotationEffect(SwiftUI.Angle(degrees: unlockAlert ? -20 : 0))
                        .animation(Animation.easeInOut(duration: 0.1).repeatCount(4))
                        .offset(y: 40)
                       
                }
            }
            .buttonStyle(.plain)
            .opacity(interpretation == nil ? 1: 0)
            .opacity(!model.isLoadingUnlock ? 1: 0 )
            
            .alert(isPresented: $unlockAlert) {
                        // Present the alert when unlockAlert is true
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Would you like to unlock this for **1 star**?\nIt may take a few moments."),
                            primaryButton: .default(Text("Yes")) {
                                // Code to run when user taps Yes
                                // Add your logic here
                                print("User tapped Yes")
                                let aName =  name?.replacingOccurrences(of: " ", with: "")  ?? ""

                                let DataToSend = AspectReadData(gender: "person", planet1: firstBody?.rawValue ?? "", planet2: secondBody?.rawValue ?? "", name: aName, orb: orb ?? 0, type: aspectType?.rawValue ?? "", user_id: belongsToUserID, requesting_user_id: Auth.auth().currentUser?.uid ?? "")
                                
                                model.unlock(aspect: DataToSend)
                                
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
             
            
            
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(model.isLoadingUnlock ? 1: 0 )
            
        }
        
    
            
        
        
        
        
        
        

    }

    func shareApp() {
            // Code to open the native share sheet
            if let appURL = URL(string: APPURL) {
                let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
                
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    // Now you have access to your SceneDelegate
                    print("Found the scne in bottom sheet")
                     sceneDelegate.windowScene?.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                }
                
             
            }
        }

    
   fileprivate func Aspectname() -> some View {
       Text( "\(firstBody?.rawValue ?? "") \(aspectType?.rawValue ?? AspectType.allCases.randomElement()!.rawValue.capitalized) \(secondBody?.rawValue ?? "") ")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
            .minimumScaleFactor(0.01)
            .lineLimit(1)
    }
    
    
    fileprivate func bodyImages() -> some View {
        Group {
            if let firstPlanet = PlanetName(rawValue: firstBody?.rawValue ?? "") {
                firstPlanet.image_3D()
                    .opacity(0.4)
                    .offset(x: 50, y: 0)
            }
            
            if let secondPlanet = PlanetName(rawValue: secondBody?.rawValue ?? "") {
                secondPlanet.image_3D()
                    .offset(x:0, y: 50)
                    .opacity(0.4)
                   
            }
        }
    }
    
    fileprivate func icons() -> some View {
        HStack(spacing: 10) {
            
            if let firstPlanet = PlanetName(rawValue: firstBody?.rawValue ?? ""){
                firstPlanet.image().conditionalColorInvert()
                    .frame(height: 25)
            }
            
            
            if let secondPlanet = PlanetName(rawValue: secondBody?.rawValue ?? ""){
                secondPlanet.image().aspectRatio(contentMode: .fit).conditionalColorInvert()
                    .frame(height: 25)
            }
        
            
           
            
        }
    }

    
    fileprivate func OrbLabel() -> HStack<TupleView<(some View, some View)>> {
        return HStack{
            
            
            
            Text("Orb")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
            
            var orb = orb?.dms ?? Double.random(in: 0..<30).dms
            
            Text("\(orb)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
        }
    }
    
    
}

#Preview {
    MiniAspectView(interpretation: nil, firstBody: .Mars, secondBody: .Moon, orb: 2.4, name: "Jupiter Pluto", belongsToUserID: "random", numSentences: 2)
    

}

/*

struct MiniPlacementVerticalPageView: View {
    var interpretations: [String: String] = [:]
    var planets: [Planet] = []

    @State  var selectedPlanet: Planet // Use a UUID or any unique identifier for planets

    var body: some View {
        TabView(selection: $selectedPlanet) {
            
            ForEach(planets) { planet in
                
            DetailedMiniPlacementView(
                        interpretation: interpretations[planet.name.rawValue],
                        planetBody: planet.name,
                        sign: planet.sign,
                        house: planet.house,
                        angle: planet.angle,
                        element: planet.element
                    )
                    //.rotationEffect(.degrees(-90), anchor: .center)
                    //.frame(width: .infinity, height: .infinity)
                    .tag(planet)
                .buttonStyle(PlainButtonStyle())
            }
        }
       // .rotationEffect(.degrees(90), anchor: .center)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            // Set the selected planet when the view appears (e.g., set it to the first planet)
           // selectedPlanetID = planets.first?.id
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                BackButton()
                    .padding()
                
            }
        }
    }
}
*/


struct LockIconView: View {
    @State private var isShaking = false

    var body: some View {
        Image(systemName: "lock.circle.fill")
            
            
    }
}

struct UnlockModalView: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        // Customize your modal view here
        VStack {
            Text("Would you like to unlock this for 1 star?")
                .padding()
            HStack {
                Button("Yes") {
                    onConfirm()
                }
                .padding()
                Button("No") {
                    onCancel()
                }
                .padding()
            }
        }
    }
}
