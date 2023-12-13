//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/16/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI
import Firebase
import EffectsLibrary

class SynastryViewModel: ObservableObject{
    @Published var message: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var synastry: Synastry?
    
    @Published var score: Double?
    
    
    
    private var insightsListener: ListenerRegistration?
    
    
    
    
    func loadInsights( with user2: String?)  {
        
        guard let user1id=Auth.auth().currentUser?.uid, let user2id = user2 else {
            print("can't load insights with no user id")
            return
        }
        
        guard !user2id.isEmpty else {
            print("user id 2 is EMPTY")
            return
        }
        insightsListener =   FirestoreService.shared.listenForSynastry(with: user2id) { result in
            switch result {
            case .success(let success):
                print("did succeed \(success)")
                self.synastry = success
                if let syn = success {
                    self.message = (syn.summary ?? "").firstNSentences(3)
                    if let d = syn.score {
                        self.score = d
                    }
                } else{
                    
                    self.message = "🌌 Click to explore and chat with me about your unique bond! 👫✨ Discover your cosmic connection and learn more about your dynamics in detail!"
                    
                }
                
            case .failure(let failure):
                print("some error getting synastry \(failure)")
                self.synastry = nil
                
                self.message = "🌌 Click to explore and chat with me about your unique bond! 👫✨ Discover your cosmic connection and learn more about your dynamics in detail!"
            }
        }
        
        
    }
    
    
    
    func tellMeAbout(them: String){
        // triggers function DashaChatbot.tellMeAbout
        //callAPI
        print("synastryViewModel.tellmeAbout")
        guard let me = Auth.auth().currentUser?.uid else { return }
        withAnimation {
            isLoading = true
        }
        
        
        let data = TellMeAboutReadData(requestingUserID: me, targetUserID: them)
        
        APIService.shared.tellMeAbout(data: data) { result in
            switch result {
            case .success(let success):
                self.isLoading = false
                print("Tell me about API response: \(success)")
            case .failure(let failure):
                print("Tell me about API response error : \(failure)")
                self.isLoading = false
            }
        }
        
    
    }
    
    deinit{
        insightsListener?.remove()
    }
}


struct UserProfileView2: View {
    
    @Injected(\.chatClient) var chatClient
    @Environment(\.presentationMode) var presentationMode

    
    @EnvironmentObject var currentUserDataModel: UserProfileModel
    @ObservedObject  var model: UserProfileModel
    
    @State var selection: Int = 0
    
    @State var showNearbyInteraction: Bool = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var hideCustomNavBar: Bool = false
    
    var menuOptions: [String]  = ["Insights", "Their Planets", "Their Story", "Media"]
    
    // Hide certain things about the profile if this is true.
    var diceUser: Bool = false
    
    @StateObject var compatViewModel: SynastryViewModel = SynastryViewModel()
    
   
    @State var showDasha: Bool = false
    
    @State var textForDasha: String = ""
    @State var unlockAlert: Bool = false
    @State  var showBlockAlert = false
    
    @State var showFireworks: Bool = false
  
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
                                print("blocking .. \(username)")
                                model.block(user: username ?? "")
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("Block \(username ?? "")")
                                    Image(systemName: "hand.raised.fill")
                                }
                            }
                            .foregroundColor(.red)
                            
                            Button(action: {
                                // Your report action here
                                model.block(user: username ?? "")
                            }) {
                                HStack {
                                    Text("Report")
                                    Image(systemName: "flag.fill")
                                }
                            }
                        }
            
        
    }
    
    
    var body: some View {
      
        ZStack{
            FireworksView()
                .opacity(showFireworks ? 1: 0)
                .onAppear{
                    if model.friendshipStatus == .friends || (model.winkedAtThem ?? false &&  model.winkedAtMe ?? false ) {
                        
                         guard UserDefaults.hasShownFireworks(forUserId: model.user?.id ?? "" ) == false  else {
                            
                             return
                        }
                        showFireworks = true
                        AmareApp().delay(15) {
                            showFireworks = false
                            UserDefaults.setFireworksShown(forUserId: model.user?.id ?? "")
                        }
                    }
                }
            VStack{
                
                if !hideCustomNavBar{
                    CustomNavigationBarView2(name: model.user?.name ?? "", username: model.user?.username ?? "", cancelFriendRequestAction: cancelFriendRequestAction, acceptFriendAction: acceptFriendAction, model: model)
                }
               
                
                ScrollView{
                //MARK: - Profile Picture
                    
                    CircularProfileImageView(profileImageUrl: diceUser ? ImageLinks.question.rawValue : model.user?.profileImageUrl, isNotable: model.user?.isNotable, winked: model.winkStatus != nil)
                            .frame(width: 100, height: 100)
                            .padding(.top, 65)
                            .onChange(of: model.user?.id) { oldValue, newValue in
                                compatViewModel.loadInsights(with: model.user?.id ?? "")
                            }
                    
                            
                    
                
                
                // MARK: - Name and Username
                ZStack{
                    
                    NameLabelView(name: model.user?.name, username: model.user?.username)
                        .onChange(of: model.user?.username, { old, new in
                            
                            print("ON USERNAME CHANGE : ==")
                            var status = model.friendshipStatus
                            
                            if status == .notFriends || status == .awaiting || status == .requested {
                                // users are not friends yet
                                print("Should change dasha text to energy..")
                                
                    
                                    textForDasha = "Add @\(model.user?.username ?? "") as a friend to chat with me about your energy together. ⚡️"
                              
                            }
                            
                            
                            else  if currentUserDataModel.user?.stars ?? 0 >= 1 && model.friendshipStatus == .friends && compatViewModel.synastry == nil  {
                                // AND if no compatibility profile yet
                               textForDasha = "🌌 Click to explore and chat with me about your unique bond! 👫✨ Discover your cosmic connection and learn more about your dynamics in detail!"
                                
                           }

                            else  if currentUserDataModel.user?.stars ?? 0 >= 1 && model.friendshipStatus == .friends && compatViewModel.synastry != nil  {
                                // AND if no compatibility profile yet
                                print("Showing compatibility text \(compatViewModel.synastry?.summary ?? "")  ")
                                textForDasha = (compatViewModel.synastry?.summary ?? "").firstNSentences(3)
                                
                           }
                            
                            else{
                               
                               print("ran none of the blocks")
                           }
                            
                            
                        })
                    
                        .onAppear(perform: {
                           
                            
                                                    
                            
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
                .blur(radius: model.friendshipStatus != .friends ? 3 : 0)
               // .redacted(reason: model.friendshipStatus != .friends ? .placeholder: [])
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
                    
                    /*
                    PlanetGridView(planets: model.natalChart?.planets ?? [],
                                   interpretations: model.natalChart?.interpretations ?? [:])
                    
                    .tag(4)
                     */
                    
                    
                }
                .frame(height: 500)
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                
                }.offset(y: diceUser ? -50: 0 )
                }
            
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
        }.onAppear {
           
            
            
        }
    }
    
    @ViewBuilder
    func insights() -> some View {
        ScrollView{
            VStack{
                
                Button{
                    
                    if currentUserDataModel.user?.stars ?? 0  >= 1  && compatViewModel.synastry == nil {
                        // user tapped button but hasn't unlocked synastry
                        withAnimation{
                            
                           
                            unlockAlert.toggle()
                           
                            
                        }
                    } else if currentUserDataModel.user?.stars ?? 0  < 1  && compatViewModel.synastry == nil {
                        textForDasha = "You're out of ⭐️'s. Add friends or come back later for more 🔥."
                    }
                    
                    else if compatViewModel.synastry != nil {
                        showDasha.toggle()
                    }
                    
                } label: {
                    ZStack{
                        ChatWithDasha(message: $compatViewModel.message)
                            .padding(.vertical)
                            .opacity(compatViewModel.isLoading ? 0: 1)
                            
                        
                            .onChange(of: compatViewModel.message) { oldValue, newValue in
                                if !newValue.isEmpty {
                                    print("got synastry so changing text")
                                   // textForDasha = newValue
                                }
                            }
                        
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .opacity(compatViewModel.isLoading ? 1: 0)
                    }
                 
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
                .disabled(model.friendshipStatus != .friends )
                // Confirmation
               
                
               

                
                
                
                
                RadialChartAdjustableSize(progress: compatViewModel.score, size: 150)
                    .padding(.top)
                
                
                
            }
         
        }
        .alert(isPresented: $unlockAlert) {
                    // Present the alert when unlockAlert is true
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Would you like to unlock compatibility insights for **1 star**?\nIt may take a few moments."),
                        primaryButton: .default(Text("Yes")) {
                      
                            print("User tapped Yes")
                            let user = model.user?.id ?? ""
                            compatViewModel.tellMeAbout(them: user)
                           
                            
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
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
