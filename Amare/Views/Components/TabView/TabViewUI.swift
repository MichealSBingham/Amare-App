//
//  TabViewUI.swift
//  Amare
//
//  Created by Micheal Bingham on 12/28/22.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .map
    @Published var showBottomTabBar: Bool = true 
    @Published var screenToShow:AppLaunchScreen = .loading
    
    @Published var showSheetForMap: Bool = false 
     
    
}

/// Enum for the screen to show during app launch
enum AppLaunchScreen{
    case loading
    case signInOrUp
    case onboarding
    case home 
    
}

enum Page {
    case home
    case discover
    case map
    case messages
    case user
}


struct CustomBottomTabBar: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var showPopUp = false
    @EnvironmentObject var model: UserProfileModel
    @EnvironmentObject var authService: AuthService
    
   // @EnvironmentObject private var sceneDelegate: SceneDelegate
    
    @EnvironmentObject var bg: BackgroundViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .home:
                    Text("This where the feed should be")
                    
                case .discover:
                    SearchAndFriendsView()
                case .map:
                    Text("")
                    
                case .messages:
                    ChatChannelListView(viewFactory: DemoAppFactory(), title: "Messages")
                case .user:
                    MainProfileView()
                      
                        
                }
                Spacer()

                // Only show the tab bar if the current page is not 'messages'
                if viewRouter.showBottomTabBar {
                    customTabBar(geometry: geometry)
                }
            }
            .environmentObject(bg)
            .environmentObject(authService)
            .environmentObject(model)
            .environmentObject(viewRouter)
           // .environmentObject(sceneDelegate)
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    // Custom Tab Bar
    private func customTabBar(geometry: GeometryProxy) -> some View {
        ZStack {
            if showPopUp {
                PlusMenu(widthAndHeight: geometry.size.width/7)
                    .offset(y: -geometry.size.height/6)
            }
            HStack {
                TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Home")
                TabBarIcon(viewRouter: viewRouter, assignedPage: .discover, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "magnifyingglass", tabName: "Search")
                plusButton(geometry: geometry)
                TabBarIcon(viewRouter: viewRouter, assignedPage: .messages, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "message.fill", tabName: "Messages")
                    .badge(10)
                TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, imageURL: model.user?.profileImageUrl ?? "", tabName: "You")
            }
            .frame(width: geometry.size.width, height: geometry.size.height/8)
            .background(Color("TabBarBackground").shadow(radius: 2).opacity(0.3))
        }
    }

    // Plus Button
    private func plusButton(geometry: GeometryProxy) -> some View {
        
        Button {
            
            withAnimation {
                viewRouter.currentPage = .map
                viewRouter.showSheetForMap = true
            }
            
        } label: {
            
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                    .shadow(radius: 4)
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width/7-6, height: geometry.size.width/7-6)
                    .foregroundColor(.amare)
                    .rotationEffect(SwiftUI.Angle(degrees: showPopUp ? 90 : 0))
            }
            .offset(y: -geometry.size.height/8/2)
        }
        .buttonStyle(.plain)

    
    }
}


struct CustomBottomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomTabBar()
            .environmentObject(UserProfileModel())
            .environmentObject(ViewRouter())
            .preferredColorScheme(.dark)
    }
}

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(.amare)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "record.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .foregroundColor(.amare)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
        }
            .transition(.scale)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    var imageURL: String? = nil
    var systemIconName: String = ""
    let tabName: String
    

    var body: some View {
        VStack {
           
            
            ZStack{
                
                CircularProfileImageView(profileImageUrl: imageURL ?? "")
                    .frame(width: width*0.35, height: height*0.35)
                    .opacity(imageURL == nil ? 0: 1)
                    .padding(.top, 10)
                
                Image(systemName: systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .padding(.top, 10)
                
                
            }
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
            .padding(.horizontal, -4)
            .onTapGesture {
                viewRouter.currentPage = assignedPage
            }
            .foregroundColor(viewRouter.currentPage == assignedPage ? Color("TabBarHighlight") : .gray)
    }
}


struct TabViewUI: View {
    
    @State var menu: Int = 0
    var body: some View {
        
        FloatingTabbar(selected: $menu)
            .preferredColorScheme(.dark)
    }
}

struct TabViewUI_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
    }
}


struct FloatingTabbar : View {
    
    @Binding var selected : Int
    @State var expand = false
    
    var body : some View{
        
     
            
            HStack{
                
                Spacer(minLength: 0)
                
                HStack{
                    
                    if !self.expand{
                        
                        Button(action: {
                            
                            self.expand.toggle()
                            
                        }) {
                            
                            Image(systemName: "arrow.left").foregroundColor(.black).padding()
                        }
                    }
                    
                    else{
                        
                        // Search Icon
                        Button(action: {
                            
                            withAnimation{
                                self.selected = 0
                            }
                           
                            
                        }) {

                            Image(self.selected == 0 ? "TabView/search2" : "TabView/search")
                                .resizable()
                                .frame(width: 25, height: 25)
                            
                                
                        }
                        Spacer()
                        
                        // MAP Icon
                        Button(action: {
                            
                            withAnimation{
                                self.selected = 1
                            }
                            
                        }) {
                            
                            Image(self.selected == 1 ? "TabView/maps2" : "TabView/maps")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        Spacer()
                        
                        Button(action: {
                            
                            withAnimation{
                                self.selected = 2
                            }
                            
                        }) {
                            
                            Image(self.selected == 2 ? "TabView/HomeIcon2" : "TabView/HomeIcon")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        Spacer()
                        
                        Button(action: {
                            
                            withAnimation{
                                self.selected = 3
                            }
                            
                        }) {
                            
                            Image(self.selected == 3 ? "TabView/messagesIcon2" : "TabView/messagesIcon")
                                .resizable()
                                .frame(width: 25, height: 25)
                                
                        }
                        
                        Spacer()
                        Button(action: {
                            
                            withAnimation{
                                self.selected = 4
                            }
                            
                        }) {
                            
                            ProfileImageView(profile_image_url: .constant(peopleImages.first!), size: CGFloat(25))
                            
                        
                        }
                        
                        
                    }
                    
                    
                }.padding(.vertical,self.expand ? 20 : 8)
                .padding(.horizontal,self.expand ? 35 : 8)
                .background(Color.white)
                .clipShape(Capsule())
                .padding(22)
                .onLongPressGesture {
                        
                        self.expand.toggle()
                }
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
            }
            
           
        
       
        

    }
}
