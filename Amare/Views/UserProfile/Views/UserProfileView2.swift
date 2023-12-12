//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/16/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

class CompatibilityViewModel: ObservableObject{
    @Published var message: String = "🌌 Click to explore and chat with me about your unique bond! 👫✨ Discover your cosmic connection and learn more about your dynamics in detail!"
    
    func tellMeAbout(them: String){
        // triggers function DashaChatbot.tellMeAbout
    }
}

struct UserProfileView2: View {
    
    @Injected(\.chatClient) var chatClient
    
    @EnvironmentObject var currentUserDataModel: UserProfileModel
    @ObservedObject  var model: UserProfileModel
    
    @State var selection: Int = 0
    
    @State var showNearbyInteraction: Bool = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var hideCustomNavBar: Bool = false
    
    var menuOptions: [String]  = ["Insights", "Their Planets", "Their Story", "Media", "Birth Chart"]
    
    // Hide certain things about the profile if this is true.
    var diceUser: Bool = false
    
    @StateObject var compatViewModel: CompatibilityViewModel = CompatibilityViewModel()
    
   
    @State var showDasha: Bool = false
  
    fileprivate func messageButton() -> some View {

        return NavigationLink(destination: DirectMessageView(with: model.user?.id ?? "").tabBar(hidden: true))
           
        
        {
            Image(systemName: "envelope.circle")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .disabled(model.friendshipStatus != .friends)
    }
    
    func winkAtTheUser() {
        guard let me = currentUserDataModel.user else {
            return
        }
        
        model.sendWink(from: me) { error in
            guard error == nil else {
                print("could not send wink : error \(error)")
                return
            }
            print("did send wink")
        }

    }

    
    fileprivate func winkButton() -> some View {
        return Button {
            guard let me = currentUserDataModel.user else {
                return
            }
            
            model.sendWink(from: me) { error in
                guard error == nil else {
                    print("could not send wink : error \(error)")
                    return
                }
                print("did send wink")
            }
        } label: {
            
            
            
           Text("😉")
                .font(
                Font.custom("SF Pro", size: 30)
                .weight(.black)
                )
                .frame(width: 30)
        }
        .buttonStyle(.plain)
      //  .opacity(model.winkStatus != nil ? 0.5 : 1 ) TODO: This is WRONG! we need to check instead if we send
    }
    
    @ViewBuilder
    fileprivate func nearbyConnectionButton() -> some View {
        Button {
            withAnimation{ showNearbyInteraction.toggle() }
        } label: {
           
            Image("location")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
               // .foregroundColor(.blue)
                
        }
        .buttonStyle(.plain)
        .disabled(model.user?.isNotable ?? false && model.user?.wikipedia_link != nil )
    }
    
    func cancelFriendRequestAction() {
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.cancelFriendRequest()
    }
    
    func addFriendAction(){
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.addFriend(currentSignedInUser: current)
    }
    
    func acceptFriendAction(){
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.acceptFriendRequest()
    }
    
    fileprivate func friendshipStatusButton() -> some View {
        Button{
            
        print("did tap friendship status")
            if model.friendshipStatus == .requested{
                cancelFriendRequestAction()
            }
            
            if model.friendshipStatus == .notFriends {
                addFriendAction()
                
            }
            
            if model.friendshipStatus == .awaiting{
                acceptFriendAction()
         
            }
            
            
        }
    label: {
        
        
        FriendshipStatusView(friendshipStatus: model.friendshipStatus)
            .frame(width: 35)
            .transition(.scale)
    }
    .disabled( model.friendshipStatus == .friends)
    }
    

    
    
    fileprivate func menuOptionsButton(username: String?) -> some View {
        MenuOptionsView()
            .contextMenu {
                            if model.friendshipStatus == .friends {
                                Button(action: {
                                    // Your remove friend action here
                                }) {
                                    HStack {
                                        Text("Remove as Friend")
                                        Image(systemName: "person.fill.xmark")
                                    }
                                }
                                .foregroundColor(.red)
                            }
                            
                            Button(action: {
                                // Your block action here
                            }) {
                                HStack {
                                    Text("Block \(username ?? "")")
                                    Image(systemName: "hand.raised.fill")
                                }
                            }
                            .foregroundColor(.red)
                            
                            Button(action: {
                                // Your report action here
                            }) {
                                HStack {
                                    Text("Report")
                                    Image(systemName: "flag.fill")
                                }
                            }
                        }
            
        
    }
    
    
    var body: some View {
      
        VStack{
            
            if !hideCustomNavBar{
                CustomNavigationBarView2(name: model.user?.name ?? "", username: model.user?.username ?? "", cancelFriendRequestAction: cancelFriendRequestAction, acceptFriendAction: acceptFriendAction, model: model)
            }
           
            
            ScrollView{ 
            //MARK: - Profile Picture
                
                CircularProfileImageView(profileImageUrl: diceUser ? ImageLinks.question.rawValue : model.user?.profileImageUrl, isNotable: model.user?.isNotable, winked: model.winkStatus != nil)
                        .frame(width: 100, height: 100)
                        .padding(.top, 65)
                
            
            
            // MARK: - Name and Username
            ZStack{
                
                NameLabelView(name: model.user?.name, username: model.user?.username)
                    .onAppear(perform: {
                        if model.friendshipStatus != .friends{
                            compatViewModel.message = "Add @\(model.user?.name ?? "") as a friend to chat me with me about your energy together. ⚡️"
                        }
                    })
                
                // MARK: - Friendship Button
                HStack{
                    Spacer()
                    friendshipStatusButton()
                        .frame(width: 35)
                        .padding()
                }
                
            }
            
            /*
             Text(oneLinerSummary ?? "" )
             .multilineTextAlignment(.center)
             // .frame(height: 38)
             .font(.caption)
             .padding(.horizontal)
             //  .border(.white)
             */
            
            
            //MARK: - Friend Count & "Big 3"
            HStack{
                
                Text(model.user?.totalFriendCount?.formattedWithAbbreviations() ?? "0")
                    .fontWeight(.black)
                // .foregroundColor(.blue)
                
                
                Text("Friends")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                PlanetName.Sun.image()
                    .frame(width: 20)
                    .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Sun)?.sign.rawValue ?? "-")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                PlanetName.Moon.image()
                    .frame(width: 15)
                    .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Moon)?.sign.rawValue ?? "-")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
                // .conditionalColorInvert()
                Text(model.natalChart?.angles.get(planet: .asc)?.sign.rawValue ?? "-")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                
                
                
            }
            
            /*
             // MARK: - Radial Chart
             RadialChart(progress: model.score)
             .padding()
             */
            //MARK: - Actions, winking messaging, ewtc
            
            HStack{
                
                
                messageButton()
                    .padding()
                
                Spacer()
                
                nearbyConnectionButton()
                    .padding()
                    .sheet(isPresented: $showNearbyInteraction,  content: {
                        FindNearbyUserView( user: model.user! , blindMode: false)
                    })
                
                
                Spacer()
                
                HeartButton(systemImage: "suit.heart.fill", status: model.winkedAtThem ?? false, activeTint: .pink, inActiveTint: .gray) {
                    
                    winkAtTheUser()
                }
                
                    .padding()
                
                
                
                
                
                
                
                
                
                
            }
            .padding()
            // .padding(.top, -10)
            
            
            // MARK: - Tab Bar
            TabBarView(currentTab: $selection, tabBarOptions: menuOptions)
                .padding()
                .padding(.top, -20)
            // MARK: - Content for Tab Bar
            TabView(selection: self.$selection) {
                    insights()
                    .padding()
                    .tag(0)
                // MARK: - Planets
                MiniPlacementsScrollView(viewedUserModel: model, interpretations: model.natalChart?.interpretations ?? [:], planets: model.natalChart?.planets ?? [])
                    .environmentObject(currentUserDataModel)
                    .tag(1)
                
                MiniAspectScrollView(viewedUserModel: model, interpretations: model.natalChart?.aspects_interpretations ?? [:], aspects: model.natalChart?.aspects ?? [], belongsToUserID: model.user?.id ?? "")
                    .tag(2)
                
                PicturesCollectionView(images: model.user?.images ?? [], viewedUserModel: model).tag(3)
                    .environmentObject(currentUserDataModel)
                
                PlanetGridView(planets: model.natalChart?.planets ?? [],
                               interpretations: model.natalChart?.interpretations ?? [:])
                .tag(4)
                
                
            }
            .frame(height: 500)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
            }.offset(y: diceUser ? -50: 0 )
            }
        
            .navigationBarBackButtonHidden(true)
            
        
    }
    
    
    /// Custom Button View
    @ViewBuilder
    func HeartButton(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(
                    systemImage: systemImage,
                    font: .body,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
    }
    
    @ViewBuilder
    func insights() -> some View {
        ScrollView{
            VStack{
                
                Button{
                    
                    if currentUserDataModel.user?.stars ?? 0  >= 1 {
                        withAnimation{
                            
                            showDasha.toggle()
                        }
                    } else {
                        compatViewModel.message = "You're out of ⭐️'s. Add friends or come back later for more 🔥."
                    }
                    
                } label: {
                    ChatWithDasha(message: compatViewModel.message)
                        .padding(.vertical)
                }.background (
                    
                    
                    
                    NavigationLink(destination: DirectMessageView(with: "dasha", ignoreBottomTabBar: true ) .onAppear(perform: {
                        withAnimation {
                            viewRouter.showBottomTabBar = false
                        }
                    })
                        .onDisappear(perform: {
                            withAnimation{
                                viewRouter.showBottomTabBar = true
                            }
                        }), isActive: $showDasha, label: {
                             EmptyView()
                        })
                    .buttonStyle(.plain)
                )
                
                
               

                
                
                
                
                RadialChartAdjustableSize(progress: model.score, size: 150)
                    .padding(.top)
                
                
                
            }
         
        }
        

        
    }

}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct UserProfileView2_Previews: PreviewProvider {
    
    static var previews: some View {
        var helper = NearbyInteractionHelper()
        NavigationView{
            UserProfileView2(model: UserProfileModel.previewInstance())
                .environmentObject(UserProfileModel.previewInstance())
                .environmentObject(helper)
                .environmentObject(BackgroundViewModel())
        }
    }
}
